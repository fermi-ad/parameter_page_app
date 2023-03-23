import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';
import "package:gql_websocket_link/gql_websocket_link.dart";
import 'package:gql_http_link/gql_http_link.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.req.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.data.gql.dart';
import 'package:ferry/ferry.dart';

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

// This class provides an interface to Fermi's DPM API via GraphQL. This widget
// should be placed near the top of your widget tree. Widgets further down can
// access this object by calling `DpmService.of(context)`.

class DpmService extends InheritedWidget {
  final Client _q;
  final Client _s;

  // Constructor. This creates the HTTP links needed to communicate with our
  // GraphQL endpoints.

  DpmService({required super.child, super.key})
      : _q = Client(
          link: HttpLink(
            Uri(
              scheme: "http",
              host: "127.0.0.1",
              port: 8080,
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
              port: 8080,
              path: "/dpm/s",
            ).toString(),
            reconnectInterval: const Duration(seconds: 1),
          ),
          cache: Cache(),
        );

  // This should return `true` if the state of widget has changed. Since it only
  // provides access to GraphQL, nothing ever changes so we always return
  // `false`.

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  // These static functions provide access to this widget from down the widget
  // chain.

  static DpmService? _maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DpmService>();

  static DpmService of(BuildContext context) {
    final DpmService? result = _maybeOf(context);

    assert(result != null, 'no DpmService found in context');
    return result!;
  }

  // Returns information about devices. The caller provides a list of device
  // names and will receive a list of `DeviceInfo` objects. The order of the
  // results in the returned list correspond to the order of the devices in the
  // source list.

  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) async {
    if (devices.isNotEmpty) {
      return _q
          // Make the request on the "query" connection. This returns a stream
          // of replies. The request type was automatically generated from the
          // schema (hence the ugly name.)

          .request(
              GGetDeviceInfoReq((b) => b.vars.names = ListBuilder(devices)))

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
}
