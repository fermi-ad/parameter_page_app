import 'package:flutter/material.dart';

class SettingControlWidget extends StatelessWidget {
  final String drf;

  final String value;

  final bool wide;

  const SettingControlWidget(
      {super.key, required this.drf, this.value = "0.0", this.wide = true});

  @override
  Widget build(BuildContext context) {
    return Text(key: key, textAlign: TextAlign.end, value);
  }
}
