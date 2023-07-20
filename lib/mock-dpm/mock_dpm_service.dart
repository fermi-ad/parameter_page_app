import 'dart:async';

import 'package:parameter_page/dpm_service.dart';

class MockDpmService extends DpmService {
  final bool useEmptyStream;

  MockDpmService({this.useEmptyStream = false});

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
  Stream<Reading> monitorSettingProperty(List<String> drfs) {
    if (useEmptyStream) {
      return const Stream<Reading>.empty();
    } else if (drfs.contains("Z:INC_SETTING")) {
      return _incSettings.stream;
    } else {
      return _settings.stream; //  + count * 0.1);
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
          const emptyBit = ExtendedStatusAttribute(value: "0");
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
                  character: "T", color: StatusColor.magenta),
              extendedStatus: [
                const ExtendedStatusAttribute(
                    description: "Henk On/Off",
                    value: "1",
                    valueText: "On",
                    color: StatusColor.green),
                const ExtendedStatusAttribute(
                    description: "Ready???",
                    value: "1",
                    valueText: "Always",
                    color: StatusColor.green),
                const ExtendedStatusAttribute(
                    description: "Remote Henk",
                    value: "0",
                    valueText: "L",
                    color: StatusColor.blue),
                const ExtendedStatusAttribute(
                    description: "Polarity",
                    value: "0",
                    valueText: "Mono",
                    color: StatusColor.red),
                const ExtendedStatusAttribute(
                    description: " test 2",
                    value: "0",
                    valueText: " good",
                    color: StatusColor.green),
                const ExtendedStatusAttribute(
                    description: "testtest",
                    value: "0",
                    valueText: "GOOD",
                    color: StatusColor.green),
                emptyBit,
                emptyBit,
                emptyBit,
                emptyBit,
                emptyBit,
                emptyBit,
                emptyBit,
                emptyBit,
                emptyBit,
                emptyBit
              ]);
        },
      ).asBroadcastStream();
    } else {
      return const Stream<DigitalStatus>.empty();
    }
  }

  void succeedAllPendingSettings() {
    _pendingSettingsStream.forEach((drf, controller) {
      controller.add(const SettingStatus(facilityCode: 1, errorCode: 0));
      controller.close();
    });
    _pendingSettingsStream.clear();
    _settingValue = _pendingSettingValue!;
  }

  void failAllPendingSettings(
      {required int facilityCode, required int errorCode}) {
    _pendingSettingsStream.forEach((drf, controller) {
      controller
          .add(SettingStatus(facilityCode: facilityCode, errorCode: errorCode));
      controller.close();
    });
    _pendingSettingsStream.clear();
    _pendingSettingValue = null;
  }

  @override
  Stream<SettingStatus> submit(
      {required String forDRF, required String newSetting}) {
    if (useEmptyStream) {
      return const Stream<SettingStatus>.empty();
    } else {
      _pendingSettingValue = double.parse(newSetting);

      final newStream = StreamController<SettingStatus>();
      _pendingSettingsStream[forDRF] = newStream;

      return newStream.stream;
    }
  }

  void updateSetting(
      {required String forDRF,
      required double value,
      required double primaryValue,
      required String rawValue}) {
    _settings.add(Reading(
        refId: 0,
        cycle: 0,
        timestamp: DateTime.now(),
        value: value,
        primaryValue: primaryValue,
        rawValue: rawValue));
  }

  void enablePeriodSettingStream({double withDefaultSettingValue = 50.0}) {
    _settingValue = withDefaultSettingValue;
    _incrementingSettingValue = withDefaultSettingValue;

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _settings.add(Reading(
          refId: 0,
          cycle: 0,
          timestamp: DateTime.now(),
          value: _settingValue,
          primaryValue: _settingValue / 10.0,
          rawValue: "8888"));

      _incSettings.add(Reading(
          refId: 0,
          cycle: 0,
          timestamp: DateTime.now(),
          value: _incrementingSettingValue,
          primaryValue: _incrementingSettingValue / 10.0,
          rawValue: "8888"));

      if (_pendingSettingsStream.isNotEmpty) {
        if (_pendingSettingsStream.keys.contains("Z:BTE200_TEMP")) {
          failAllPendingSettings(facilityCode: 57, errorCode: -10);
        } else {
          succeedAllPendingSettings();
        }
      }

      _incrementingSettingValue += 1;
    });
  }

  final Map<String, StreamController<SettingStatus>> _pendingSettingsStream =
      {};

  final StreamController<Reading> _settings =
      StreamController<Reading>.broadcast();

  final StreamController<Reading> _incSettings =
      StreamController<Reading>.broadcast();

  double _settingValue = 0.0;

  double _incrementingSettingValue = 0.0;

  double? _pendingSettingValue;
}
