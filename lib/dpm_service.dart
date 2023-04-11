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
