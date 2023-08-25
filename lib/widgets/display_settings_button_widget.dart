import 'package:flutter/material.dart';

class DisplaySettingsButtonWidget extends StatelessWidget {
  final bool wide;

  final Function() onPressed;

  const DisplaySettingsButtonWidget(
      {super.key, required this.wide, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: "Display Settings",
        child: TextButton(
          key: const Key('display_settings_button'),
          onPressed: onPressed,
          child: const Text("Display Settings"),
        ));
  }
}
