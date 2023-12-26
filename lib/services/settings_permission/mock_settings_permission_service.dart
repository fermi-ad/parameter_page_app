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
      {required SettingsRequestDuration forDuration,
      Function()? onTimerExpired}) async {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      if (mockFailSettingsPermissionRequests) {
        return Future.error("Fake settings permission request failure.");
      }

      if (mockDenySettingsPermissionRequests) {
        return false;
      }

      _onTimerExpired = onTimerExpired;

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

      _onTimerExpired = null;

      return true;
    });
  }

  void enableMockSettings() {
    _mockSettingsPermission = true;
  }

  void expireMockSettingsTimer() {
    _mockSettingsPermission = false;
    _onTimerExpired?.call();
  }

  bool _mockSettingsPermission = false;

  Function()? _onTimerExpired;
}
