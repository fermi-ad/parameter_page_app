import 'dart:async';

import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class MockSettingsPermissionService implements SettingsPermissionService {
  @override
  bool get settingsAllowed {
    return _mockSettingsPermission;
  }

  @override
  int get settingsEnabledSecondsRemaining => _remaining;

  @override
  List<SettingsRequestDuration> get allowedSettingDurations => [
        SettingsRequestDuration.fiveSeconds,
        SettingsRequestDuration.tenMinutes,
        SettingsRequestDuration.oneHour,
        SettingsRequestDuration.eightHours,
        SettingsRequestDuration.indefinitely
      ];

  bool mockDenySettingsPermissionRequests = false;

  bool mockFailSettingsPermissionRequests = false;

  @override
  Future<bool> requestSettingsPermission(
      {required SettingsRequestDuration forDuration,
      Function()? onTimerExpired,
      Function(int secondsRemaining)? onTimerTick}) async {
    return Future<bool>.delayed(const Duration(seconds: 1), () {
      if (mockFailSettingsPermissionRequests) {
        return Future.error("Fake settings permission request failure.");
      }

      if (mockDenySettingsPermissionRequests) {
        return false;
      }

      _onTimerExpired = onTimerExpired;
      _onTimerTick = onTimerTick;

      _mockSettingsPermission = true;

      if (forDuration.seconds > 0) {
        _startTimer(forNSeconds: forDuration.seconds);
      }

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

      _disableSettingsAndResetTimer();

      return true;
    });
  }

  void enableMockSettings() {
    _mockSettingsPermission = true;
  }

  void expireMockSettingsTimer() {
    _disableSettingsAndResetTimer();
    _onTimerExpired?.call();
  }

  void _startTimer({required forNSeconds}) {
    _timer?.cancel();

    _remaining = forNSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining == 0) {
        _disableSettingsAndResetTimer();
        _onTimerExpired?.call();
        _onTimerExpired = null;
      } else {
        _remaining -= 1;
        _onTimerTick?.call(_remaining);
      }
    });
    _onTimerTick?.call(_remaining);
  }

  void _disableSettingsAndResetTimer() {
    _mockSettingsPermission = false;
    _stopAndResetTimer();
  }

  void _stopAndResetTimer() {
    _timer?.cancel();
    _remaining = 0;
  }

  Timer? _timer;

  int _remaining = 0;

  bool _mockSettingsPermission = false;

  Function()? _onTimerExpired;

  Function(int)? _onTimerTick;
}
