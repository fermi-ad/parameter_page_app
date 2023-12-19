import 'package:flutter/material.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class SettingsPermissionWidget extends StatelessWidget {
  final SettingsPermissionService service;

  SettingsPermissionWidget({super.key, required this.service})
      : _permissionState = service.settingsAllowed
            ? _SettingPermissionState.enabled
            : _SettingPermissionState.disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
        child: Row(key: const Key("settings-permission"), children: [
          _buildIndicator(),
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: _buildStatusText()),
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: _buildPopupMenuButton())
        ]));
  }

  Widget _buildIndicator() {
    Color color;
    String keyName;
    switch (_permissionState) {
      case _SettingPermissionState.disabled:
        color = Colors.red;
        keyName = "disabled";
        break;

      case _SettingPermissionState.enabled:
        color = Colors.green;
        keyName = "enabled";
        break;

      case _SettingPermissionState.pending:
        color = Colors.white;
        keyName = "pending";
        break;
    }

    return Icon(
        key: Key("settings-permission-indicator-$keyName"),
        Icons.circle,
        color: color,
        size: 16.0);
  }

  Widget _buildStatusText() {
    switch (_permissionState) {
      case _SettingPermissionState.disabled:
        return const Text("Settings disabled");
      case _SettingPermissionState.pending:
        return const Text("Requesting settings permission...");
      case _SettingPermissionState.enabled:
        return const Text("Settings allowed");
    }
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton<String>(
        icon: const Icon(Icons.expand_more),
        itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                  value: "10 Minutes", child: Text("10 Minutes")),
              const PopupMenuItem<String>(
                  value: "1 Hour", child: Text("1 Hour"))
            ]);
  }

  final _SettingPermissionState _permissionState;
}

enum _SettingPermissionState { disabled, pending, enabled }
