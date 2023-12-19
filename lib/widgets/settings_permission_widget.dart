import 'package:flutter/material.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class SettingsPermissionWidget extends StatelessWidget {
  final SettingsPermissionService service;

  const SettingsPermissionWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final settingsAreAllowed = service.settingsAllowed;

    return Row(key: const Key("settings-permission"), children: [
      settingsAreAllowed ? const Text("Enabled") : const Text("Disabled"),
      settingsAreAllowed
          ? const Icon(
              key: Key("settings-permission-indicator-enabled"), Icons.circle)
          : const Icon(
              key: Key("settings-permission-indicator-disabled"), Icons.circle)
    ]);
  }
}
