// This class provides an interface to Fermi's DPM API via GraphQL. This widget
// should be placed near the top of your widget tree. Widgets further down can
// access this object by calling `DpmService.of(context)`.

import 'package:flutter_test/flutter_test.dart';
import 'package:built_collection/built_collection.dart';
import "package:gql_websocket_link/gql_websocket_link.dart";
import 'package:gql_http_link/gql_http_link.dart';
import 'package:ferry/ferry.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/DPM.schema.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.req.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/get_device_info.data.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/set_device.req.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.data.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.req.gql.dart';
import 'package:parameter_page/gql-dpm/schema/__generated__/stream_data.var.gql.dart';
import 'package:parameter_page/widgets/util.dart';

import 'dart:developer' as developer;

import 'dpm_service.dart';

class GraphQLDpmService extends DpmService {
  final Client _q;
  final Client _s;

  // Constructor. This creates the HTTP links needed to communicate with our
  // GraphQL endpoints.

  GraphQLDpmService()
      : _q = Client(
          link: HttpLink(
            Uri(
              scheme: "https",
              host: "acsys-proxy.fnal.gov",
              port: 8000,
              path: "/acsys",
            ).toString(),
          ),
          cache: Cache(),
        ),
        _s = Client(
          link: WebSocketLink(
              Uri(
                scheme: "wss",
                host: "acsys-proxy.fnal.gov",
                port: 8000,
                path: "/acsys",
              ).toString(),
              reconnectInterval: const Duration(seconds: 1),
              initialPayload: {
                "headers": {"sec-websocket-protocol": "graphql-ws"}
              }),
          cache: Cache(),
        );

  // Common code needed to do RPCs. The caller sends in a protobuf request and,
  // optionally, a function to translate the protobuf reply into some other data
  // type.

  Future<Result> _rpc<TData, TVars, Result>(OperationRequest<TData, TVars> req,
          {Result Function(TData)? xlat}) =>
      _q
          .request(req)
          .where((response) => !response.loading)
          .first
          .then((value) {
        if (value.hasErrors) {
          throw Exception(value.graphqlErrors);
        } else {
          final data = value.data;

          if (data != null) {
            return xlat != null ? xlat(data) : data as Result;
          } else {
            throw Exception("no data was returned from request");
          }
        }
      });

  // Returns information about devices. The caller provides a list of device
  // names and will receive a list of `DeviceInfo` objects. The order of the
  // results in the returned list correspond to the order of the devices in the
  // source list.
  @override
  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) async {
    if (devices.isNotEmpty) {
      final req =
          GGetDeviceInfoReq((b) => b..vars.names = ListBuilder(devices));

      return _rpc(req,
          xlat: (GGetDeviceInfoData data) =>
              data.deviceInfo.result.map(_convertToDevInfo).toList());
    } else {
      throw DPMInvArgException("empty device list");
    }
  }

  // Private conversion method to convert an obnoxiously named, nested class
  // into our nicer, flatter one. Used by `getDeviceInfo()`.

  static DeviceInfo _convertToDevInfo(GGetDeviceInfoData_deviceInfo_result e) {
    if (e is GGetDeviceInfoData_deviceInfo_result__asDeviceInfo) {
      final DeviceInfoProperty? rProp = e.reading != null
          ? DeviceInfoProperty(
              primaryUnits: e.reading!.primaryUnits,
              commonUnits: e.reading!.commonUnits)
          : null;
      final DeviceInfoProperty? sProp = e.setting != null
          ? DeviceInfoProperty(
              primaryUnits: e.setting!.primaryUnits,
              commonUnits: e.setting!.commonUnits)
          : null;

      return DeviceInfo(
        di: 0,
        name: "",
        description: e.description,
        reading: rProp,
        setting: sProp,
      );
    } else {
      if (e is GGetDeviceInfoData_deviceInfo_result__asErrorReply) {
        throw UnimplementedError("getDeviceInfo returned an error");
      } else {
        throw UnimplementedError("getDeviceInfo unexpected response");
      }
    }
  }

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
        .handleError((error) =>
            developer.log("error: $error", name: "gql.monitorDevices"))
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

  @override
  Stream<DigitalStatus> monitorDigitalStatusDevices(List<String> drfs) {
    return const Stream<DigitalStatus>.empty();
  }

  @override
  Stream<Reading> monitorSettingProperty(List<String> drfs) =>
      monitorDevices(Util.toSettingDRFs(from: drfs));

  // Performs a setting request. `forDRF` is the DRF string representing the
  // target device and property to receive the setting. `newSetting` is the
  // value of the setting. The future this function returns will resolve to the
  // status of the setting.

  @override
  Future<SettingStatus> submit(
      {required String forDRF, required DeviceValue newSetting}) {
    // Define a nested function which converts the GraphQL reply into a
    // SettingStatus.

    xlat(e) => SettingStatus(
        facilityCode: e.setDevice.status ~/ 256,
        errorCode: e.setDevice.status & 255);

    // Build the request.

    final req = GSetDeviceReq((b) => b
      ..vars.device = forDRF
      ..vars.value = newSetting._toGDevValue());

    return _rpc(req, xlat: xlat);
  }

  @override
  Future<SettingStatus> sendCommand(
          {required String toDRF, required String value}) =>
      submit(forDRF: toDRF, newSetting: DevText(value));
}

// And an extension to the DevValue hierarchy which translates a value into a
// GraphQL `GDevValue` type. No other code needs to be exposed to this
// interface, so we only make the extension visible in this module.

extension on DeviceValue {
  GDevValueBuilder _toGDevValue() {
    return switch (this) {
      DevRaw(value: var v) => GDevValueBuilder()..rawVal = ListBuilder(v),
      DevScalar(value: var v) => GDevValueBuilder()..scalarVal = v,
      DevScalarArray(value: var v) => GDevValueBuilder()
        ..scalarArrayVal = ListBuilder(v),
      DevText(value: var v) => GDevValueBuilder()..textVal = v,
      DevTextArray(value: var v) => GDevValueBuilder()
        ..textArrayVal = ListBuilder(v)
    };
  }
}
