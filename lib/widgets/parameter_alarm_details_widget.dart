import 'package:flutter/material.dart';

import '../dpm_service.dart';

class ParameterAlarmDetailsWidget extends StatelessWidget {
  final DeviceInfoAlarmBlock alarmBlock;
  final String drf;

  const ParameterAlarmDetailsWidget(
      {super.key, required this.drf, required this.alarmBlock});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 250,
        child: Column(children: [
          Row(key: Key("parameter_alarm_nominal_$drf"), children: [
            const Text(overflow: TextOverflow.ellipsis, "Nominal:"),
            const Spacer(),
            Text(overflow: TextOverflow.ellipsis, alarmBlock.nominal)
          ]),
          Row(key: Key("parameter_alarm_tolerance_$drf"), children: [
            const Text(overflow: TextOverflow.ellipsis, "Tolerance:"),
            const Spacer(),
            Text(overflow: TextOverflow.ellipsis, alarmBlock.tolerance)
          ]),
          Row(key: Key("parameter_alarm_min_$drf"), children: [
            const Text(overflow: TextOverflow.ellipsis, "Min:"),
            const Spacer(),
            Text(overflow: TextOverflow.ellipsis, alarmBlock.min)
          ]),
          Row(key: Key("parameter_alarm_max_$drf"), children: [
            const Text(overflow: TextOverflow.ellipsis, "Max:"),
            const Spacer(),
            Text(overflow: TextOverflow.ellipsis, alarmBlock.max)
          ]),
        ]));
  }
}
