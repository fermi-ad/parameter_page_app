import 'dart:async';

import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class MockSettingsPermissionService implements SettingsPermissionService {
  @override
  bool get settingsAllowed {
    return _mockSettingsPermission;
  }

  @override
  int get settingsEnabledSecondsRemaining => _remaining;

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

      _startTimer(forNSeconds: forDuration.seconds);

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
    _mockSettingsPermission = false;
    _onTimerExpired?.call();
    _timer?.cancel();
  }

  void _startTimer({required forNSeconds}) {
    _remaining = forNSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining == 0) {
        _disableSettingsAndResetTimer();
        _onTimerExpired?.call();
      } else {
        _remaining -= 1;
        _onTimerTick?.call(_remaining);
      }
    });
    _onTimerTick?.call(_remaining);
  }

  void _disableSettingsAndResetTimer() {
    _mockSettingsPermission = false;
    _onTimerExpired = null;
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
