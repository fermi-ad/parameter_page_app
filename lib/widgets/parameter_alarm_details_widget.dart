import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';

class ParameterAlarmDetailsWidget extends StatelessWidget {
  final DeviceInfoAnalogAlarm alarmBlock;
  final String drf;

  const ParameterAlarmDetailsWidget(
      {super.key, required this.drf, required this.alarmBlock});

  @override
  Widget build(BuildContext context) {
    final textStyle =
        TextStyle(color: Theme.of(context).colorScheme.outline, fontSize: 12.0);
    const valueStyle = TextStyle(fontSize: 12.0);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(key: Key("parameter_alarm_nominal_$drf"), children: [
        Text(overflow: TextOverflow.ellipsis, "Nominal: ", style: textStyle),
        Text(
            overflow: TextOverflow.ellipsis,
            alarmBlock.nominal,
            style: valueStyle),
        Row(key: Key("parameter_alarm_tolerance_$drf"), children: [
          Text(" (+/- ", style: textStyle),
          Text(alarmBlock.tolerance, style: valueStyle),
          Text(")", style: textStyle)
        ])
      ]),
      Row(children: [
        Row(key: Key("parameter_alarm_min_$drf"), children: [
          Text(overflow: TextOverflow.ellipsis, "Min: ", style: textStyle),
          Text(
              overflow: TextOverflow.ellipsis,
              alarmBlock.min,
              style: valueStyle)
        ]),
        Row(key: Key("parameter_alarm_max_$drf"), children: [
          Text(overflow: TextOverflow.ellipsis, " Max: ", style: textStyle),
          Text(
              overflow: TextOverflow.ellipsis,
              alarmBlock.max,
              style: valueStyle)
        ])
      ]),
    ]);
  }
}
