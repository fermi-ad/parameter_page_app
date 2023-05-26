import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

enum DisplayUnits {
  commonUnits,
  primaryUnits,
  raw;

  String get asString {
    switch (this) {
      case DisplayUnits.commonUnits:
        return "Common Units";
      case DisplayUnits.primaryUnits:
        return "Primary Units";
      case DisplayUnits.raw:
        return "Raw";
      default:
        AssertionError("default case in DisplayUnits.asString!");
        return "invalid DisplayUnits!";
    }
  }
}

class DisplaySettings {
  DisplayUnits units;

  DisplaySettings({this.units = DisplayUnits.commonUnits});
}

class DisplaySettingsWidget extends StatefulWidget {
  const DisplaySettingsWidget(
      {super.key, required this.initialSettings, required this.onChanged});

  final Function(DisplaySettings) onChanged;

  final DisplaySettings initialSettings;

  @override
  State<DisplaySettingsWidget> createState() => _DisplaySettingsState();

  static const displayUnits = [
    DisplayUnits.raw,
    DisplayUnits.primaryUnits,
    DisplayUnits.commonUnits
  ];
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
              onPressed: _popupUnitsMenu,
              value: Text(_settings.units.asString),
            ),
            SettingsTile.switchTile(
                key: const Key("display_settings_tile_alarm_details"),
                initialValue: false,
                onToggle: (bool value) {},
                leading: const Icon(Icons.alarm),
                title: const Text("Show Parameter Alarm Details (off)"))
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
              key: Key("display_settings_tile_units_menuitem_${e.asString}"),
              value: e,
              child: Text(e.asString),
            ),
          )
          .toList(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _settings.units = value;
        });
        widget.onChanged(_settings);
      }
    });
  }

  late DisplaySettings _settings;
}