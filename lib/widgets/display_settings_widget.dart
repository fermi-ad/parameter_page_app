import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class DisplaySettingsWidget extends StatelessWidget {
  const DisplaySettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          key: const Key("display_settings_appbar"),
          title: const Text('Display Settings'),
        ),
        body: SettingsList(sections: [
          SettingsSection(title: const Text("Display"), tiles: <SettingsTile>[
            SettingsTile.navigation(
                key: const Key("display_settings_tile_unit"),
                leading: const Icon(Icons.language),
                title: const Text("Units"),
                value: const Text("Common Units"))
          ])
        ]));
  }
}
