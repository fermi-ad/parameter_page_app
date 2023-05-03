import 'package:flutter/material.dart';

class DisplaySettingsWidget extends StatelessWidget {
  const DisplaySettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          key: const Key("display_settings_appbar"),
          title: const Text('Display Settings'),
        ),
        body: Row(
            key: const Key("display_units_indicator"),
            children: const [Text("Common Units")]));
  }
}
