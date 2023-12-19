import 'package:flutter/material.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';

class SettingsPermissionWidget extends StatelessWidget {
  const SettingsPermissionWidget(
      {super.key, required SettingsPermissionService service});

  @override
  Widget build(BuildContext context) {
    return const Row(key: Key("settings-permission"), children: [
      Text("Disabled"),
      Icon(key: Key("settings-permission-indicator-disabled"), Icons.circle)
    ]);
  }
}
