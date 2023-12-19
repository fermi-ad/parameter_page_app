import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class MockSettingsPermissionService implements SettingsPermissionService {
  @override
  bool get settingsAllowed {
    return _mockSettingsPermission;
  }

  void enableMockSettings() {
    _mockSettingsPermission = true;
  }

  bool _mockSettingsPermission = false;
}
