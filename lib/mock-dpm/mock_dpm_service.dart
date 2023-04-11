import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parameter_page/gql-dpm/dpm_service.dart';

class MockDpmService extends DpmService {
  const MockDpmService({required super.child, super.key});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) async {
    List<DeviceInfo> deviceInfoList = [];

    for (String drf in devices) {
      deviceInfoList
          .add(DeviceInfo(di: 0, name: drf, description: "device description"));
    }

    return deviceInfoList;
  }

  @override
  Stream<Reading> monitorDevices(List<String> drfs) {
    final Stream<Reading> stream = Stream<Reading>.periodic(
      const Duration(seconds: 1),
      (count) {
        return Reading(
            refId: 0,
            cycle: 0,
            timestamp: DateTime(2023),
            value: 100.0); //  + count * 0.1);
      },
    ).asBroadcastStream();

    return stream;
  }
}
