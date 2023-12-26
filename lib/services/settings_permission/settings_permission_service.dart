enum SettingsRequestDuration { tenMinutes, oneHour, eightHours }

abstract class SettingsPermissionService {
  bool get settingsAllowed;

  int get settingsEnabledSecondsRemaining;

  Future<bool> requestSettingsPermission(
      {required SettingsRequestDuration forDuration,
      Function()? onTimerExpired,
      Function(int)? onTimerTick});

  Future<bool> requestSettingsBeDisabled();
}
