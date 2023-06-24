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
        case "G:AMANDA":
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
                  min: "62.00",
                  max: "82.00"),
              basicStatus: const DeviceInfoBasicStatus(
                  onOffProperty: BasicStatusProperty(
                      character0: ".",
                      color0: StatusColor.green,
                      character1: "*",
                      color1: StatusColor.red),
                  readyTrippedProperty: BasicStatusProperty(
                      character0: ".",
                      color0: StatusColor.green,
                      character1: "T",
                      color1: StatusColor.red),
                  remoteLocalProperty: BasicStatusProperty(
                      character0: ".",
                      color0: StatusColor.blue,
                      character1: "L",
                      color1: StatusColor.blue),
                  positiveNegativeProperty: BasicStatusProperty(
                      character0: "*",
                      color0: StatusColor.blue,
                      character1: "T",
                      color1: StatusColor.magenta)));
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
                  min: "62.00",
                  max: "82.00"));
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

  @override
  Stream<DigitalStatus> monitorDigitalStatusDevices(List<String> drfs) {
    if (useEmptyStream) {
      return const Stream<DigitalStatus>.empty();
    } else if (drfs.contains("G:AMANDA")) {
      return Stream<DigitalStatus>.periodic(
        const Duration(seconds: 1),
        (count) {
          return DigitalStatus(
              refId: 0,
              cycle: 0,
              timestamp: DateTime(2023),
              onOff: const BasicStatusAttribute(
                  character: ".", color: StatusColor.green),
              readyTripped: const BasicStatusAttribute(
                  character: "T", color: StatusColor.red),
              remoteLocal: const BasicStatusAttribute(
                  character: "L", color: StatusColor.blue),
              positiveNegative: const BasicStatusAttribute(
                  character: "T", color: StatusColor.magenta));
        },
      ).asBroadcastStream();
    } else {
      return const Stream<DigitalStatus>.empty();
    }
  }
}
