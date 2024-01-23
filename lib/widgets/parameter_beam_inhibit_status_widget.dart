import 'package:flutter/material.dart';
import 'package:flutter_controls_core/service/acsys/service.dart';

class ParameterBeamInhibitStatusWidget extends StatelessWidget {
  final String drf;

  final DeviceInfoDigitalAlarm alarmInfo;

  const ParameterBeamInhibitStatusWidget(
      {super.key, required this.drf, required this.alarmInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: Key("parameter_digitalalarm_beaminhibit_$drf"),
        child: Tooltip(
            message: "Digital alarm does not inhibit beam",
            child: Icon(Icons.pan_tool,
                size: 16,
                color: alarmInfo.abort
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.background)));
  }
}
