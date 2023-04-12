import 'dart:async';

import 'package:parameter_page/dpm_service.dart';

class MockDpmService extends DpmService {
  const MockDpmService();

  @override
  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) async {
    return devices
        .map((drf) =>
            DeviceInfo(di: 0, name: drf, description: "device description"))
        .toList();
  }

  @override
  Stream<Reading> monitorDevices(List<String> drfs) {
    return Stream<Reading>.periodic(
      const Duration(seconds: 1),
      (count) {
        return Reading(
            refId: 0,
            cycle: 0,
            timestamp: DateTime(2023),
            value: 100.0); //  + count * 0.1);
      },
    ).asBroadcastStream();
  }
}
