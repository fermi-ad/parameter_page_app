import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';
import "package:gql_websocket_link/gql_websocket_link.dart";
import 'package:gql_http_link/gql_http_link.dart';
import 'package:ferry/ferry.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.req.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.data.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.data.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.req.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.var.gql.dart';

import 'dart:developer' as developer;

// Declare an exception type that's specific to the DPM API.

abstract class DPMException implements Exception {
  final String message;

  const DPMException(this.message);

  @override
  String toString() => message;
}

class DPMInvArgException extends DPMException {
  DPMInvArgException(String message) : super("InvArg: $message");
}

class DPMTypeException extends DPMException {
  DPMTypeException(String message) : super("Type: $message");
}

class DPMGraphQLException extends DPMException {
  DPMGraphQLException(String message) : super("GraphQL: $message");
}

// The classes in this section are used to return results from the queries /
// subscriptions. The generated classes have unusual names and have nested
// structure. We'd rather present a simpler result type. This also protects us
// from API changes; hopefully we won't have to change these result classes
// much, if at all.

class DeviceInfo {
  final int di;
  final String name;
  final String description;
  final String? units;

  const DeviceInfo(
      {required this.di,
      required this.name,
      required this.description,
      this.units});
}

class Reading {
  final int refId;
  final int status;
  final int cycle;
  final DateTime timestamp;
  final double? value;

  const Reading(
      {required this.refId,
      this.status = 0,
      required this.cycle,
      required this.timestamp,
      this.value});
}

abstract class DpmService {
  const DpmService();

  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices);

  Stream<Reading> monitorDevices(List<String> drfs);
}

// This class provides an interface to Fermi's DPM API via GraphQL. This widget
// should be placed near the top of your widget tree. Widgets further down can
// access this object by calling `DpmService.of(context)`.

class GraphQLDpmService extends DpmService {
  final Client _q;
  final Client _s;

  // Constructor. This creates the HTTP links needed to communicate with our
  // GraphQL endpoints.

  GraphQLDpmService()
      : _q = Client(
          link: HttpLink(
            Uri(
              scheme: "http",
              host: "127.0.0.1",
              port: 8000,
              path: "/dpm/q",
            ).toString(),
          ),
          cache: Cache(),
        ),
        _s = Client(
          link: WebSocketLink(
            Uri(
              scheme: "ws",
              host: "127.0.0.1",
              port: 8000,
              path: "/dpm/s",
            ).toString(),
            reconnectInterval: const Duration(seconds: 1),
          ),
          cache: Cache(),
        );

  // Returns information about devices. The caller provides a list of device
  // names and will receive a list of `DeviceInfo` objects. The order of the
  // results in the returned list correspond to the order of the devices in the
  // source list.
  @override
  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) async {
    if (devices.isNotEmpty) {
      final req =
          GGetDeviceInfoReq((b) => b..vars.names = ListBuilder(devices));

      return _q
          // Make the request on the "query" connection. This returns a stream
          // of replies. The request type was automatically generated from the
          // schema (hence the ugly name.)

          .request(req)

          // Insert this identity mapping so we can check for errors.

          .map((event) {
            if (event.hasErrors) {
              developer.log("errors: ${event.graphqlErrors}",
                  name: "gql.getDeviceInfo");
            }

            return event;
          })

          // Ignore items showing the progress of the request. We only want the
          // final response when there's data or an error.

          .where((event) => !event.loading)

          // Since this is a query, there should only be one reply (after
          // filtering out the progress entries), so grab the first (and only)
          // reply. This method returns a Future with the reply.

          .first

          // We need to convert the Future's result because it's a list of
          // `GGetDeviceInfoData_acceleratorData` objects and we want a list of
          // `DeviceInfo` objects.

          .then(
            (response) {
              if (!response.hasErrors) {
                // Iterate across the list to generate a new one with our "nicer"
                // class type.

                return response.data!.acceleratorData
                    .map(_convertToDevInfo)
                    .toList();
              } else {
                // Any GraphQL errors should be re-raised (but wrapped in our
                // DPM-specific exception.)

                throw DPMGraphQLException(response.graphqlErrors.toString());
              }
            },
          );
    } else {
      throw DPMInvArgException("empty device list");
    }
  }

  // Private conversion method to convert an obnoxiously named, nested class
  // into our nicer, flatter one. Used by `getDeviceInfo()`.

  static DeviceInfo _convertToDevInfo(GGetDeviceInfoData_acceleratorData e) =>
      DeviceInfo(
        di: e.data.di,
        name: e.data.name,
        description: e.data.description,
        units: e.data.units,
      );

  // Returns a stream of readings for the devices specified in the parameter
  // list. The `Reading` class has a `refId` field which indicates to which
  // device in the passed array the current reading belongs. If `value` is null,
  // the `status` field will hold the ACNET error status. No more readings will
  // be sent for a device in error.
  @override
  Stream<Reading> monitorDevices(List<String> drfs) {
    final req = GStreamDataReq((b) => b..vars.drfs = ListBuilder(drfs));

    return _s
        .request(req)
        .map((event) {
          if (event.hasErrors) {
            developer.log("error: ${event.graphqlErrors}",
                name: "gql.monitorDevices");
          }

          return event;
        })
        .where((event) => !event.loading)
        .map(_convertToReading);
  }

  // Convert the incoming GraphQL messages into `Reading` objects.

  static Reading _convertToReading(
      OperationResponse<GStreamDataData, GStreamDataVars> e) {
    // If the packet doesn't have GraphQL errors, then we can process the
    // payload.

    if (!e.hasErrors) {
      final GStreamDataData_acceleratorData data = e.data!.acceleratorData;
      final GStreamDataData_acceleratorData_data_result result =
          data.data.result;

      // If the result has a scalar value, return a `Reading` with the value.

      if (result is GStreamDataData_acceleratorData_data_result__asScalar) {
        return Reading(
            refId: data.refId,
            cycle: data.cycle,
            timestamp: data.data.timestamp,
            value: result.scalarValue);
      }

      // If the result is a status, then the value is `null` and we save the
      // status code.

      if (result
          is GStreamDataData_acceleratorData_data_result__asStatusReply) {
        return Reading(
            refId: data.refId,
            cycle: data.cycle,
            timestamp: data.data.timestamp,
            status: result.status);
      }

      // We are only supporting a single, scalar value for the moment. Any types
      // we don't yet support will report an error and tear down the stream.

      throw DPMTypeException("can't handle ${result.G__typename} types");
    } else {
      throw DPMGraphQLException(e.graphqlErrors.toString());
    }
  }
}
