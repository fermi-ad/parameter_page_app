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

class DeviceInfoAnalogAlarm {
  final String nominal;
  final String tolerance;
  final String min;
  final String max;

  const DeviceInfoAnalogAlarm(
      {required this.nominal,
      required this.tolerance,
      required this.min,
      required this.max});
}

class DeviceInfoProperty {
  final String? commonUnits;
  final String? primaryUnits;

  const DeviceInfoProperty(
      {required this.commonUnits, required this.primaryUnits});
}

class BasicStatusProperty {
  final String character0;
  final StatusColor color0;
  final String character1;
  final StatusColor color1;

  const BasicStatusProperty(
      {required this.character0,
      required this.color0,
      required this.character1,
      required this.color1});
}

class DeviceInfoBasicStatus {
  final BasicStatusProperty? onOffProperty;
  final BasicStatusProperty? readyTrippedProperty;
  final BasicStatusProperty? remoteLocalProperty;
  final BasicStatusProperty? positiveNegativeProperty;

  const DeviceInfoBasicStatus(
      {this.onOffProperty,
      this.readyTrippedProperty,
      this.remoteLocalProperty,
      this.positiveNegativeProperty});
}

class DeviceInfoDigitalControl {
  final int value;
  final String shortName;
  final String longName;

  const DeviceInfoDigitalControl(
      {required this.value, required this.shortName, required this.longName});
}

class DeviceInfo {
  final int di;
  final String name;
  final String description;
  final DeviceInfoProperty? reading;
  final DeviceInfoProperty? setting;
  final DeviceInfoAnalogAlarm? alarm;
  final DeviceInfoBasicStatus? basicStatus;
  final List<DeviceInfoDigitalControl> digControl;

  const DeviceInfo(
      {required this.di,
      required this.name,
      required this.description,
      this.reading,
      this.setting,
      this.alarm,
      this.basicStatus,
      this.digControl = const []});
}

class Reading {
  final int refId;
  final int status;
  final int cycle;
  final DateTime timestamp;
  final double? value;
  final String? rawValue;
  final double? primaryValue;

  const Reading(
      {required this.refId,
      this.status = 0,
      required this.cycle,
      required this.timestamp,
      this.value,
      this.rawValue,
      this.primaryValue});
}

enum StatusColor { black, blue, green, cyan, red, magenta, yellow, white }

class BasicStatusAttribute {
  final String character;
  final StatusColor color;

  const BasicStatusAttribute({required this.character, required this.color});
}

class ExtendedStatusAttribute {
  final String? description;
  final String value;
  final String? valueText;
  final StatusColor? color;

  const ExtendedStatusAttribute(
      {this.description, required this.value, this.valueText, this.color});
}

class DigitalStatus {
  final int refId;
  final int status;
  final int cycle;
  final DateTime timestamp;
  final BasicStatusAttribute? onOff;
  final BasicStatusAttribute? readyTripped;
  final BasicStatusAttribute? remoteLocal;
  final BasicStatusAttribute? positiveNegative;
  final List<ExtendedStatusAttribute>? extendedStatus;

  const DigitalStatus(
      {required this.refId,
      this.status = 0,
      required this.cycle,
      required this.timestamp,
      this.onOff,
      this.readyTripped,
      this.remoteLocal,
      this.positiveNegative,
      this.extendedStatus});
}

class SettingStatus {
  final int facilityCode;
  final int errorCode;

  const SettingStatus({required this.facilityCode, required this.errorCode});
}

abstract class DpmService {
  const DpmService();

  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices);

  Stream<Reading> monitorDevices(List<String> drfs);

  Stream<Reading> monitorSettingProperty(List<String> drfs);

  Stream<DigitalStatus> monitorDigitalStatusDevices(List<String> drfs);

  Stream<SettingStatus> submit(
      {required String forDRF, required String newSetting});
}
