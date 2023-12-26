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

      if (mockDenySettingsPermissionRequests) {
        return false;
      }

      _mockSettingsPermission = true;

      return true;
    });
  }

  @override
  Future<bool> requestSettingsBeDisabled() async {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      if (mockFailSettingsPermissionRequests) {
        return Future.error("Fake settings permission request failure.");
      }

      if (mockDenySettingsPermissionRequests) {
        return false;
      }

      _mockSettingsPermission = false;

      return true;
    });
  }

  void enableMockSettings() {
    _mockSettingsPermission = true;
  }

  void expireMockSettingsTimer() {}

  bool _mockSettingsPermission = false;
}
