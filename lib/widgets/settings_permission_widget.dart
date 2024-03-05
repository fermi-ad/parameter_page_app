import 'package:flutter/material.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class SettingsPermissionWidget extends StatefulWidget {
  final SettingsPermissionService service;

  final Function(bool)? onChanged;

  const SettingsPermissionWidget(
      {super.key, required this.service, this.onChanged});

  @override
  State<SettingsPermissionWidget> createState() {
    return _SettingPermissionState();
  }
}

class _SettingPermissionState extends State<SettingsPermissionWidget> {
  @override
  void initState() {
    _permissionState = widget.service.settingsAllowed
        ? _SettingPermissionStatus.enabled
        : _SettingPermissionStatus.disabled;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
        child: Row(key: const Key("settings-permission"), children: [
          _buildIndicator(),
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: _buildStatusText()),
          Visibility(
              visible: _showTimer(),
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: _buildTimerDisplay())),
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: _buildPopupMenuButton())
        ]));
  }

  Widget _buildTimerDisplay() {
    return Container(
        key: const Key("settings-permission-timer"), child: Text(_timerText));
  }

  Widget _buildIndicator() {
    if (_permissionState == _SettingPermissionStatus.pending) {
      return _buildPendingIndicator();
    } else {
      return _buildEnableDisableIndicator();
    }
  }

  Widget _buildPendingIndicator() {
    return const SizedBox(
        width: 16.0, height: 16.0, child: CircularProgressIndicator());
  }

  Widget _buildEnableDisableIndicator() {
    Color color;
    String keyName;
    IconData icon;
    if (_permissionState == _SettingPermissionStatus.disabled) {
      color = Theme.of(context).colorScheme.tertiary;
      keyName = "disabled";
      icon = Icons.lock;
    } else {
      color = Theme.of(context).colorScheme.secondary;
      keyName = "enabled";
      icon = Icons.lock_open;
    }

    return Icon(icon,
        key: Key("settings-permission-indicator-$keyName"),
        color: color,
        size: 24.0);
  }

  Widget _buildStatusText() {
    switch (_permissionState) {
      case _SettingPermissionStatus.disabled:
        return const Text("Settings disabled");
      case _SettingPermissionStatus.pending:
        return const Text("Request pending...");
      case _SettingPermissionStatus.enabled:
        return const Text("Settings allowed");
    }
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton<SettingsRequestDuration>(
        icon: const Icon(Icons.expand_more),
        onSelected: (SettingsRequestDuration selection) {
          if (selection == SettingsRequestDuration.disabled) {
            _handleRequestSettingsBeDisabled();
          } else {
            _handleRequestSettingsPermission(selection);
          }
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuItem<SettingsRequestDuration>> ret = widget
              .service.allowedSettingDurations
              .map((settingDuration) => PopupMenuItem<SettingsRequestDuration>(
                  value: settingDuration, child: Text(settingDuration.text)))
              .toList();

          if (widget.service.settingsAllowed) {
            ret.insert(
                0,
                const PopupMenuItem<SettingsRequestDuration>(
                    value: SettingsRequestDuration.disabled,
                    child: Text("Disable settings")));
          }

          return ret;
        });
  }

  bool _showTimer() {
    return _permissionState == _SettingPermissionStatus.enabled &&
        _timerDuration != SettingsRequestDuration.indefinitely;
  }

  void _handleRequestSettingsPermission(
      SettingsRequestDuration duration) async {
    _goToPendingStatus();

    await widget.service
        .requestSettingsPermission(
            forDuration: duration,
            onTimerExpired: _goToDisabledStatus,
            onTimerTick: _handleTimerTick)
        .then((bool requestGranted) {
      _goToEnabledStatus(duration: duration);
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Request failed - $error")));
      setState(() => _permissionState = _previousState);
    });
  }

  void _handleRequestSettingsBeDisabled() async {
    _goToPendingStatus();

    await widget.service
        .requestSettingsBeDisabled()
        .then((bool requestGranted) {
      setState(() => _permissionState = requestGranted
          ? _SettingPermissionStatus.disabled
          : _SettingPermissionStatus.enabled);
      widget.onChanged?.call(!requestGranted);
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Request failed - $error")));
      setState(() => _permissionState = _previousState);
    });
  }

  void _handleTimerTick(int secondsRemaining) {
    setState(() => _timerText = _formatCountdown(secondsRemaining));
  }

  void _goToDisabledStatus() {
    setState(() {
      _permissionState = _SettingPermissionStatus.disabled;
      _timerDuration = null;
    });
    widget.onChanged?.call(false);
  }

  void _goToEnabledStatus({required SettingsRequestDuration duration}) {
    setState(() {
      _timerDuration = duration;
      _permissionState = _SettingPermissionStatus.enabled;
    });
    widget.onChanged?.call(true);
  }

  void _goToPendingStatus() {
    setState(() {
      _timerDuration = null;
      _previousState = _permissionState;
      _permissionState = _SettingPermissionStatus.pending;
    });
  }

  String _formatCountdown(int secondsRemaining) {
    final duration = Duration(seconds: secondsRemaining);
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return "$hours:${_twoDigits(minutes)}:${_twoDigits(seconds)}";
    } else {
      return "$minutes:${_twoDigits(seconds)}";
    }
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return "$n";
    } else {
      return "0$n";
    }
  }

  _SettingPermissionStatus _permissionState = _SettingPermissionStatus.disabled;

  _SettingPermissionStatus _previousState = _SettingPermissionStatus.disabled;

  String _timerText = "10:00";

  SettingsRequestDuration? _timerDuration;
}

enum _SettingPermissionStatus { disabled, pending, enabled }
