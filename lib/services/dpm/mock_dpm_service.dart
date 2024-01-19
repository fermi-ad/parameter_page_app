import 'dart:async';
import 'package:flutter_controls_core/flutter_controls_core.dart';

class MockDpmService implements ACSysServiceAPI {
  bool getDeviceInfoShouldFail = false;

  final bool useEmptyStream;

  MockDpmService({this.useEmptyStream = false});

  @override
  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) async {
    if (getDeviceInfoShouldFail) {
      return Future.error("Fake getDeviceInfo(..) failure.");
    }

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
        case "Z:BTE200_TEMP":
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
                      invert: false,
                      maskVal: 1,
                      matchVal: 1,
                      character0: ".",
                      color0: StatusColor.green,
                      character1: "*",
                      color1: StatusColor.red)),
              digControl: [
                const DeviceInfoDigitalControl(
                    value: 0, shortName: "On", longName: "On"),
                const DeviceInfoDigitalControl(
                    value: 1, shortName: "OFF", longName: "Off"),
                const DeviceInfoDigitalControl(
                    value: 2, shortName: "HEAT", longName: "Heat"),
                const DeviceInfoDigitalControl(
                    value: 3, shortName: "COOL", longName: "Cool")
              ]);
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
                      invert: false,
                      maskVal: 1,
                      matchVal: 1,
                      character0: ".",
                      color0: StatusColor.green,
                      character1: "*",
                      color1: StatusColor.red),
                  readyTrippedProperty: BasicStatusProperty(
                      invert: false,
                      maskVal: 1,
                      matchVal: 1,
                      character0: ".",
                      color0: StatusColor.green,
                      character1: "T",
                      color1: StatusColor.red),
                  remoteLocalProperty: BasicStatusProperty(
                      invert: false,
                      maskVal: 1,
                      matchVal: 1,
                      character0: ".",
                      color0: StatusColor.blue,
                      character1: "L",
                      color1: StatusColor.blue),
                  positiveNegativeProperty: BasicStatusProperty(
                      invert: false,
                      maskVal: 1,
                      matchVal: 1,
                      character0: "*",
                      color0: StatusColor.blue,
                      character1: "T",
                      color1: StatusColor.magenta)),
              digControl: [
                const DeviceInfoDigitalControl(
                    value: 0, shortName: "RESET", longName: "Reset"),
                const DeviceInfoDigitalControl(
                    value: 1, shortName: "ON", longName: "On"),
                const DeviceInfoDigitalControl(
                    value: 2, shortName: "OFF", longName: "Off"),
                const DeviceInfoDigitalControl(
                    value: 3, shortName: "POSITIVE", longName: "Positive"),
                const DeviceInfoDigitalControl(
                    value: 4, shortName: "NEGATIVE", longName: "Negative")
              ]);
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
    } else if (drfs.contains("Z:BTE200_TEMP")) {
      return Stream<DigitalStatus>.periodic(
        const Duration(seconds: 1),
        (count) {
          const emptyBit = ExtendedStatusAttribute(value: 0);
          return DigitalStatus(
              refId: 0,
              cycle: 0,
              timestamp: DateTime(2023),
              onOff: const BasicStatusAttribute(
                  character: ".", color: StatusColor.green),
              extendedStatus: [
                const ExtendedStatusAttribute(
                    description: "On/Off",
                    value: 1,
                    valueText: "On",
                    color: StatusColor.green),
                const ExtendedStatusAttribute(
                    description: "Cool/Heat",
                    value: 1,
                    valueText: "Cooling",
                    color: StatusColor.blue),
                emptyBit,
                emptyBit,
                emptyBit,
                emptyBit,
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
    } else if (drfs.contains("G:AMANDA")) {
      return Stream<DigitalStatus>.periodic(
        const Duration(seconds: 1),
        (count) {
          const emptyBit = ExtendedStatusAttribute(value: 0);
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
                    value: 1,
                    valueText: "On",
                    color: StatusColor.green),
                const ExtendedStatusAttribute(
                    description: "Ready???",
                    value: 1,
                    valueText: "Always",
                    color: StatusColor.green),
                const ExtendedStatusAttribute(
                    description: "Remote Henk",
                    value: 0,
                    valueText: "L",
                    color: StatusColor.blue),
                const ExtendedStatusAttribute(
                    description: "Polarity",
                    value: 0,
                    valueText: "Mono",
                    color: StatusColor.red),
                const ExtendedStatusAttribute(
                    description: " test 2",
                    value: 0,
                    valueText: " good",
                    color: StatusColor.green),
                const ExtendedStatusAttribute(
                    description: "testtest",
                    value: 0,
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

  @override
  Stream<AnalogAlarmStatus> monitorAnalogAlarmProperty(List<String> drfs) {
    if (useEmptyStream) {
      return const Stream<AnalogAlarmStatus>.empty();
    }

    if (!_analogAlarmStreams.containsKey(drfs[0])) {
      final AnalogAlarmState initialState;
      if (drfs[0] == "Z:BTE200_TEMP") {
        initialState = AnalogAlarmState.alarming;
      } else if (drfs[0] == "Z:NO_SET") {
        initialState = AnalogAlarmState.bypassed;
      } else {
        initialState = AnalogAlarmState.notAlarming;
      }

      _analogAlarmStreams[drfs[0]] = MockAlarmStream(
          currentState: initialState,
          controller: StreamController<AnalogAlarmStatus>.broadcast(),
          timer: Timer.periodic(const Duration(seconds: 1), (Timer timer) {
            _analogAlarmStreams[drfs[0]]!.controller.add(AnalogAlarmStatus(
                refId: 0,
                cycle: 0,
                timestamp: DateTime.now(),
                state: _analogAlarmStreams[drfs[0]]!.currentState));
          }));
    }

    return _analogAlarmStreams[drfs[0]]!.controller.stream;
  }

  void raiseAlarm({required String forDRF, bool isByPassed = false}) {
    _analogAlarmStreams[forDRF]!.currentState =
        isByPassed ? AnalogAlarmState.bypassed : AnalogAlarmState.alarming;
  }

  void noAlarm({required String forDRF, bool isByPassed = false}) {
    _analogAlarmStreams[forDRF]!.currentState =
        isByPassed ? AnalogAlarmState.bypassed : AnalogAlarmState.notAlarming;
  }

  void succeedAllPendingSettings() {
    _pendingSettingsCompleter.forEach((drf, controller) {
      controller.complete(const SettingStatus(facilityCode: 1, errorCode: 0));
    });
    _pendingSettingsCompleter.clear();
    if (pendingSettingValue != null) {
      _settingValue = pendingSettingValue!;
    }
  }

  void failAllPendingSettings(
      {required int facilityCode, required int errorCode}) {
    _pendingSettingsCompleter.forEach((drf, controller) {
      controller.complete(
          SettingStatus(facilityCode: facilityCode, errorCode: errorCode));
    });
    _pendingSettingsCompleter.clear();
    pendingSettingValue = null;
  }

  @override
  Future<SettingStatus> submit(
      {required String forDRF, required DeviceValue newSetting}) async {
    if (forDRF.contains(".ANALOG.ENABLE")) {
      final base = forDRF.split(".")[0];
      final scalar = newSetting as DevScalar;
      if (scalar.value == 0) {
        _analogAlarmStreams[base]!.currentState = AnalogAlarmState.bypassed;
      } else if (scalar.value == 1) {
        _analogAlarmStreams[base]!.currentState = base == "Z:BTE200_TEMP"
            ? AnalogAlarmState.alarming
            : AnalogAlarmState.notAlarming;
      }
    }

    if (useEmptyStream) {
      return const SettingStatus(facilityCode: 0, errorCode: 0);
    } else {
      if (newSetting is DevScalar) {
        pendingSettingValue = newSetting;
      } else {
        throw UnimplementedError(
            "Only scalar setting supported by MockDPMService");
      }

      final newCompleter = Completer<SettingStatus>();
      _pendingSettingsCompleter[forDRF] = newCompleter;

      return newCompleter.future;
    }
  }

  @override
  Future<SettingStatus> sendCommand(
      {required String toDRF, required String value}) async {
    if (useEmptyStream) {
      return const SettingStatus(facilityCode: 0, errorCode: 0);
    } else {
      final newCompleter = Completer<SettingStatus>();
      _pendingSettingsCompleter[toDRF] = newCompleter;

      return newCompleter.future;
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
    _settingValue = DevScalar(withDefaultSettingValue);
    _incrementingSettingValue = withDefaultSettingValue;

    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _settings.add(Reading(
          refId: 0,
          cycle: 0,
          timestamp: DateTime.now(),
          value: _settingValue.value,
          primaryValue: _settingValue.value / 10.0,
          rawValue: "8888"));

      _incSettings.add(Reading(
          refId: 0,
          cycle: 0,
          timestamp: DateTime.now(),
          value: _incrementingSettingValue,
          primaryValue: _incrementingSettingValue / 10.0,
          rawValue: "8888"));

      if (_pendingSettingsCompleter.isNotEmpty) {
        if (_pendingSettingsCompleter.keys.contains("Z:BTE200_TEMP")) {
          failAllPendingSettings(facilityCode: 57, errorCode: -10);
        } else {
          succeedAllPendingSettings();
        }
      }

      _incrementingSettingValue += 1;
    });
  }

  final Map<String, Completer<SettingStatus>> _pendingSettingsCompleter = {};

  final StreamController<Reading> _settings =
      StreamController<Reading>.broadcast();

  final StreamController<Reading> _incSettings =
      StreamController<Reading>.broadcast();

  final Map<String, MockAlarmStream> _analogAlarmStreams = {};

  DevScalar _settingValue = const DevScalar(0.0);

  double _incrementingSettingValue = 0.0;

  DevScalar? pendingSettingValue;
}

class MockAlarmStream {
  StreamController<AnalogAlarmStatus> controller;
  AnalogAlarmState currentState;
  Timer timer;

  MockAlarmStream(
      {required this.controller,
      required this.currentState,
      required this.timer});
}
