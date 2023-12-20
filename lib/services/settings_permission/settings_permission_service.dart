enum SettingsRequestDuration { tenMinutes, oneHour, eightHours }

abstract class SettingsPermissionService {
  bool get settingsAllowed;

  Future<bool> requestSettingsPermission(
      {required SettingsRequestDuration forDuration});

  Future<bool> requestSettingsBeDisabled();
}
