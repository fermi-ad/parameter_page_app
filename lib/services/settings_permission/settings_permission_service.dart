enum SettingsRequestDuration {
  disabled(seconds: 0, text: "Settings disabled"),
  tenMinutes(seconds: 10 * 60, text: "10 Minutes"),
  oneHour(seconds: 1 * 60 * 60, text: "1 Hour"),
  eightHours(seconds: 8 * 60 * 60, text: "8 Hours");

  const SettingsRequestDuration({required this.seconds, required this.text});

  final int seconds;

  final String text;
}

abstract class SettingsPermissionService {
  bool get settingsAllowed;

  int get settingsEnabledSecondsRemaining;

  Future<bool> requestSettingsPermission(
      {required SettingsRequestDuration forDuration,
      Function()? onTimerExpired,
      Function(int)? onTimerTick});

  Future<bool> requestSettingsBeDisabled();
}
