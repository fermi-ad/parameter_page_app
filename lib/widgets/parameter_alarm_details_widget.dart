import 'package:flutter/material.dart';

import '../services/dpm/dpm_service.dart';

class ParameterAlarmDetailsWidget extends StatelessWidget {
  final DeviceInfoAnalogAlarm alarmBlock;
  final String drf;

  const ParameterAlarmDetailsWidget(
      {super.key, required this.drf, required this.alarmBlock});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.grey, fontSize: 12.0);
    const valueStyle = TextStyle(fontSize: 12.0);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(key: Key("parameter_alarm_nominal_$drf"), children: [
        const Text(
            overflow: TextOverflow.ellipsis, "Nominal: ", style: textStyle),
        Text(
            overflow: TextOverflow.ellipsis,
            alarmBlock.nominal,
            style: valueStyle),
        Row(key: Key("parameter_alarm_tolerance_$drf"), children: [
          const Text(" (+/- ", style: textStyle),
          Text(alarmBlock.tolerance, style: valueStyle),
          const Text(")", style: textStyle)
        ])
      ]),
      Row(children: [
        Row(key: Key("parameter_alarm_min_$drf"), children: [
          const Text(
              overflow: TextOverflow.ellipsis, "Min: ", style: textStyle),
          Text(
              overflow: TextOverflow.ellipsis,
              alarmBlock.min,
              style: valueStyle)
        ]),
        Row(key: Key("parameter_alarm_max_$drf"), children: [
          const Text(
              overflow: TextOverflow.ellipsis, " Max: ", style: textStyle),
          Text(
              overflow: TextOverflow.ellipsis,
              alarmBlock.max,
              style: valueStyle)
        ])
      ]),
    ]);
  }
}
