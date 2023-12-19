import 'package:flutter/material.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class SettingsPermissionWidget extends StatelessWidget {
  final SettingsPermissionService service;

  const SettingsPermissionWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final settingsAreAllowed = service.settingsAllowed;

    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 10.0),
        child: Row(key: const Key("settings-permission"), children: [
          settingsAreAllowed
              ? const Icon(
                  key: Key("settings-permission-indicator-enabled"),
                  Icons.circle,
                  color: Colors.green,
                  size: 16.0)
              : const Icon(
                  key: Key("settings-permission-indicator-disabled"),
                  Icons.circle,
                  color: Colors.red,
                  size: 16.0),
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: settingsAreAllowed
                  ? const Text("Settings allowed")
                  : const Text("Settings disabled")),
          Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
              child: PopupMenuButton<String>(
                  icon: const Icon(Icons.expand_more),
                  itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                            value: "10 Minutes", child: Text("10 Minutes")),
                        const PopupMenuItem<String>(
                            value: "1 Hour", child: Text("1 Hour"))
                      ]))
        ]));
  }
}
