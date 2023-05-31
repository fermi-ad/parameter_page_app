import 'package:flutter/material.dart';

class ParameterAlarmDetailsWidget extends StatelessWidget {
  final String nominal;
  final String tolerance;
  final String min;
  final String max;
  final String drf;

  const ParameterAlarmDetailsWidget(
      {super.key,
      required this.drf,
      required this.nominal,
      required this.tolerance,
      required this.min,
      required this.max});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(
          key: Key("parameter_alarm_nominal_$drf"),
          children: const [Text("Nominal:"), Spacer(), Text("72.00")]),
      const Spacer(),
      Column(
          key: Key("parameter_alarm_tolerance_$drf"),
          children: const [Text("Tolerance:"), Spacer(), Text("10.00")]),
      const Spacer(),
      Column(
          key: Key("parameter_alarm_min_$drf"),
          children: const [Text("Min:"), Spacer(), Text("64.80")]),
      const Spacer(),
      Column(
          key: Key("parameter_alarm_max_$drf"),
          children: const [Text("Max:"), Spacer(), Text("79.20")]),
    ]);
  }
}
