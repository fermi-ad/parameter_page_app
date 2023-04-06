import 'package:flutter/material.dart';

class MockDpmService extends InheritedWidget {
  MockDpmService({required super.child, super.key}) {}

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
