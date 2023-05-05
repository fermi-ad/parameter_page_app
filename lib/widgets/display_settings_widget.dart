import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class DisplaySettingsWidget extends StatefulWidget {
  const DisplaySettingsWidget({super.key});

  @override
  State<DisplaySettingsWidget> createState() => _DisplaySettingsState();
}

class _DisplaySettingsState extends State<DisplaySettingsWidget> {
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
                key: const Key("display_settings_tile_units"),
                leading: const Icon(Icons.language),
                title: const Text("Units"),
                value: Text(_units),
                onPressed: _popupUnitsMenu)
          ])
        ]));
  }

  void _popupUnitsMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fill,
      items: _displayUnits
          .map(
            (e) => PopupMenuItem(
              key: Key("display_settings_tile_units_menuitem_$e"),
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _units = value;
        });
      }
    });
  }

  static const _displayUnits = ["Primary Units", "Common Units", "Raw"];

  String _units = "Common Units";
}
