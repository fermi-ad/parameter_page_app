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
      color = Colors.red;
      keyName = "disabled";
      icon = Icons.lock;
    } else {
      color = Colors.green;
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
    return PopupMenuButton<String>(
        icon: const Icon(Icons.expand_more),
        onSelected: (String selection) {
          if (selection == "Disable settings") {
            _handleRequestSettingsBeDisabled();
          } else {
            _handleRequestSettingsPermission(selection);
          }
        },
        itemBuilder: (BuildContext context) {
          List<PopupMenuItem<String>> ret = [
            const PopupMenuItem<String>(
                value: "10 Minutes", child: Text("10 Minutes")),
            const PopupMenuItem<String>(value: "1 Hour", child: Text("1 Hour"))
          ];

          if (widget.service.settingsAllowed) {
            ret.insert(
                0,
                const PopupMenuItem<String>(
                    value: "Disable settings",
                    child: Text("Disable settings")));
          }

          return ret;
        });
  }

  void _handleRequestSettingsPermission(String duration) async {
    _goToPendingStatus();

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

  void _handleRequestSettingsBeDisabled() async {
    _goToPendingStatus();

    await widget.service
        .requestSettingsBeDisabled()
        .then((bool requestGranted) {
      setState(() => _permissionState = requestGranted
          ? _SettingPermissionStatus.disabled
          : _SettingPermissionStatus.enabled);
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Request failed - $error")));
      setState(() => _permissionState = _previousState);
    });
  }

  void _goToPendingStatus() {
    setState(() {
      _previousState = _permissionState;
      _permissionState = _SettingPermissionStatus.pending;
    });
  }

  _SettingPermissionStatus _permissionState = _SettingPermissionStatus.disabled;

  _SettingPermissionStatus _previousState = _SettingPermissionStatus.disabled;
}

enum _SettingPermissionStatus { disabled, pending, enabled }
