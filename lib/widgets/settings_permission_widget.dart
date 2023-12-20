import 'package:flutter/material.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class SettingsPermissionWidget extends StatefulWidget {
  final SettingsPermissionService service;

  const SettingsPermissionWidget({super.key, required this.service});

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
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: _buildPopupMenuButton())
        ]));
  }

  Widget _buildIndicator() {
    Color color;
    String keyName;
    switch (_permissionState) {
      case _SettingPermissionStatus.disabled:
        color = Colors.red;
        keyName = "disabled";
        break;

      case _SettingPermissionStatus.enabled:
        color = Colors.green;
        keyName = "enabled";
        break;

      case _SettingPermissionStatus.pending:
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
      case _SettingPermissionStatus.disabled:
        return const Text("Settings disabled");
      case _SettingPermissionStatus.pending:
        return const Text("Request pending...");
      case _SettingPermissionStatus.enabled:
        return const Text("Settings allowed");
    }
  }

  Widget _buildPopupMenuButton() {
    return PopupMenuButton<String>(
        icon: const Icon(Icons.expand_more),
        onSelected: _handleRequestSettingsPermission,
        itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                  value: "10 Minutes", child: Text("10 Minutes")),
              const PopupMenuItem<String>(
                  value: "1 Hour", child: Text("1 Hour"))
            ]);
  }

  void _handleRequestSettingsPermission(String duration) async {
    setState(() {
      _previousState = _permissionState;
      _permissionState = _SettingPermissionStatus.pending;
    });

    await widget.service
        .requestSettingsPermission(
            forDuration: SettingsRequestDuration.tenMinutes)
        .then((bool requestGranted) {
      setState(() => _permissionState = _SettingPermissionStatus.enabled);
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Request failed - $error")));
      setState(() => _permissionState = _previousState);
    });
  }

  _SettingPermissionStatus _permissionState = _SettingPermissionStatus.disabled;

  _SettingPermissionStatus _previousState = _SettingPermissionStatus.disabled;
}

enum _SettingPermissionStatus { disabled, pending, enabled }
