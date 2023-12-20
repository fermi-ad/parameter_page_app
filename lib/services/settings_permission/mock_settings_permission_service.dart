import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class MockSettingsPermissionService implements SettingsPermissionService {
  @override
  bool get settingsAllowed {
    return _mockSettingsPermission;
  }

  bool mockDenySettingsPermissionRequests = false;

  bool mockFailSettingsPermissionRequests = false;

  @override
  Future<bool> requestSettingsPermission(
      {required SettingsRequestDuration forDuration}) async {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      if (mockFailSettingsPermissionRequests) {
        return Future.error("Fake settings permission request failure.");
      }

      return !mockDenySettingsPermissionRequests;
    });
  }

  void enableMockSettings() {
    _mockSettingsPermission = true;
  }

  bool _mockSettingsPermission = false;
}
