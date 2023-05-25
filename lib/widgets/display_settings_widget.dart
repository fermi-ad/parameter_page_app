import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class DisplaySettings {
  String units;

  DisplaySettings({this.units = "Common Units"});
}

class DisplaySettingsWidget extends StatefulWidget {
  const DisplaySettingsWidget(
      {super.key, required this.initialSettings, required this.onChanged});

  final Function(DisplaySettings) onChanged;

  final DisplaySettings initialSettings;

  @override
  State<DisplaySettingsWidget> createState() => _DisplaySettingsState();

  static const displayUnits = ["Primary Units", "Common Units", "Raw"];
}

class _DisplaySettingsState extends State<DisplaySettingsWidget> {
  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings;
  }

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
                leading: const Icon(Icons.abc),
                title: const Text("Units"),
                value: Text(_settings.units),
                onPressed: _popupUnitsMenu)
          ])
        ]));
  }

  void _popupUnitsMenu(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fill,
      items: DisplaySettingsWidget.displayUnits
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
          _settings.units = value;
        });

        DisplaySettings newSettings = DisplaySettings(units: value);
        widget.onChanged(newSettings);
      }
    });
  }

  late DisplaySettings _settings;
}
