import 'package:parameter_page/services/settings_permission/mock_settings_permission_service.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';
import 'package:test/test.dart';

void main() {
  // This is the system under test:
  SettingsPermissionService service = MockSettingsPermissionService();

  group('settingsAllowed', () {
    test("settingsAllowed, should be false initially", () async {
      // Given nothing
      // Then settingsAllowed should be false
      expect(service.settingsAllowed, false);
    });
  });
}
