import 'dart:async';

import 'package:parameter_page/dpm_service.dart';

class MockDpmService extends DpmService {
  final bool useEmptyStream;

  const MockDpmService({this.useEmptyStream = false});

  @override
  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) async {
    return devices.map((drf) {
      switch (drf) {
        case "Z:NO_READ":
          return DeviceInfo(
              di: 0,
              name: drf,
              description: "device description",
              reading: null,
              setting: const DeviceInfoProperty(
                  commonUnits: "cUS", primaryUnits: "pUS"));
        case "Z:NO_SET":
          return DeviceInfo(
              di: 0,
              name: drf,
              description: "device description",
              reading: const DeviceInfoProperty(
                  commonUnits: "cUR", primaryUnits: "pUR"),
              setting: null);
        case "Z:NO_ALARMS":
          return DeviceInfo(
              di: 0,
              name: drf,
              description: "device description",
              reading: const DeviceInfoProperty(
                  commonUnits: "cUR", primaryUnits: "pUR"),
              setting: const DeviceInfoProperty(
                  commonUnits: "cUS", primaryUnits: "pUS"));
        default:
          return DeviceInfo(
              di: 0,
              name: drf,
              description: "device description",
              reading: const DeviceInfoProperty(
                  commonUnits: "cUR", primaryUnits: "pUR"),
              setting: const DeviceInfoProperty(
                  commonUnits: "cUS", primaryUnits: "pUS"),
              alarm: const DeviceInfoAnalogAlarm(
                  nominal: "72.00",
                  tolerance: "10.00",
                  min: "64.80",
                  max: "79.20"));
      }
    }).toList();
  }

  @override
  Stream<Reading> monitorDevices(List<String> drfs) {
    if (useEmptyStream) {
      return const Stream<Reading>.empty();
    } else {
      return Stream<Reading>.periodic(
        const Duration(seconds: 1),
        (count) {
          return Reading(
              refId: 0,
              cycle: 0,
              timestamp: DateTime(2023),
              value: 100.0,
              rawValue: "FFFF",
              primaryValue: 10.0); //  + count * 0.1);
        },
      ).asBroadcastStream();
    }
  }
}
