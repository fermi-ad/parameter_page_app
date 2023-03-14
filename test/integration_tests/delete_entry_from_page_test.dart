import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:parameter_page/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Delete Entry from Page', () {
    testWidgets('Confirm no, should not delete entry', (tester) async {
      // Then the parameter is still displayed on the page
    });
  });
}
