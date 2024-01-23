import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:flutter/widgets.dart';

enum BeamInhibitState { wontInhibit, willInhibit, byPassed }

class DataAcquisitionWidget extends InheritedWidget {
  final ACSysServiceAPI service;

  const DataAcquisitionWidget(
      {super.key, required super.child, required this.service});

  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) {
    return service.getDeviceInfo(devices);
  }

  Stream<Reading> monitorDevices(List<String> drfs) {
    return service.monitorDevices(drfs);
  }

  Stream<Reading> monitorSettingProperty(List<String> drfs) {
    return service.monitorSettingProperty(drfs);
  }

  Stream<DigitalStatus> monitorDigitalStatusDevices(List<String> drfs) {
    return service.monitorDigitalStatusDevices(drfs);
  }

  Stream<AlarmStatus> monitorAnalogAlarmDevices(List<String> drfs) {
    return service.monitorAnalogAlarmProperty(drfs);
  }

  Stream<AlarmStatus> monitorDigitalAlarmDevices(List<String> drfs) {
    return service.monitorDigitalAlarmProperty(drfs);
  }

  Stream<bool> monitorDigitalAlarmBeamAbortInhibit(String drf) async* {
    yield* monitorDevices(["$drf.DIGITAL.ALARM.ABORT_INHIBIT"])
        .map((v) => v.value == 1 ? true : false);
  }

  bool isACNETDRF(String val) {
    var drfRegEx = RegExp(r"^[A-Za-z][:_|][A-Za-z0-9@,]{1,255}$");

    return drfRegEx.hasMatch(val);
  }

  bool isProcessVariable(String val) {
    var pvRegEx = RegExp(r"^([A-Za-z0-9:_]{1,255}):([A-Za-z0-9:_]{1,255})$");

    return pvRegEx.hasMatch(val);
  }

  // This should return `true` if the state of widget has changed. Since it only
  // provides access to GraphQL, nothing ever changes so we always return
  // `false`.

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  // These static functions provide access to this widget from down the widget
  // chain.

  static DataAcquisitionWidget? _maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataAcquisitionWidget>();
  }

  static DataAcquisitionWidget of(BuildContext context) {
    final DataAcquisitionWidget? result = _maybeOf(context);

    assert(result != null, 'no DataAcquisitionWidget found in context');
    return result!;
  }

  void submit(
      {required String forDRF,
      required String newSetting,
      Function? onSuccess,
      Function(int, int)? onFailure}) {
    service
        .submit(forDRF: forDRF, newSetting: DevScalar(double.parse(newSetting)))
        .then((SettingStatus status) {
      if (status.errorCode == 0) {
        onSuccess?.call();
      } else {
        onFailure?.call(status.facilityCode, status.errorCode);
      }
    });
  }

  void sendCommand(
      {required String toDRF,
      required String value,
      Function? onSuccess,
      Function(int, int)? onFailure}) {
    service
        .sendCommand(toDRF: toDRF, value: value)
        .then((SettingStatus status) {
      if (status.errorCode == 0) {
        onSuccess?.call();
      } else {
        onFailure?.call(status.facilityCode, status.errorCode);
      }
    });
  }
}
