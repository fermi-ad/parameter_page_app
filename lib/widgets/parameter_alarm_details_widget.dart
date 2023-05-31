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
    return SizedBox(
        width: 250,
        child: Column(children: [
          Row(key: Key("parameter_alarm_nominal_$drf"), children: const [
            Text(overflow: TextOverflow.ellipsis, "Nominal:"),
            Spacer(),
            Text(overflow: TextOverflow.ellipsis, "72.00")
          ]),
          Row(key: Key("parameter_alarm_tolerance_$drf"), children: const [
            Text(overflow: TextOverflow.ellipsis, "Tolerance:"),
            Spacer(),
            Text(overflow: TextOverflow.ellipsis, "10.00")
          ]),
          Row(key: Key("parameter_alarm_min_$drf"), children: const [
            Text(overflow: TextOverflow.ellipsis, "Min:"),
            Spacer(),
            Text(overflow: TextOverflow.ellipsis, "64.80")
          ]),
          Row(key: Key("parameter_alarm_max_$drf"), children: const [
            Text(overflow: TextOverflow.ellipsis, "Max:"),
            Spacer(),
            Text(overflow: TextOverflow.ellipsis, "79.20")
          ]),
        ]));
  }
}
