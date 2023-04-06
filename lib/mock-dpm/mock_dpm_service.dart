import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parameter_page/gql-dpm/dpm_service.dart';

class MockDpmService extends DpmService {
  const MockDpmService({required super.child, super.key});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;

  @override
  Future<List<DeviceInfo>> getDeviceInfo(List<String> devices) async {
    return Future<List<DeviceInfo>>([
      const DeviceInfo(di: 0, name: "bad name", description: "bad description")
    ] as FutureOr<List<DeviceInfo>> Function());
  }

  @override
  Stream<Reading> monitorDevices(List<String> drfs) {
    return const Stream<Reading>.empty();
  }
}
