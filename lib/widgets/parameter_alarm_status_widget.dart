import 'package:flutter/material.dart';
import 'package:flutter_controls_core/service/acsys/service.dart';

class ParameterAlarmStatusWidget extends StatelessWidget {
  final AnalogAlarmStatus status;

  const ParameterAlarmStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status.state) {
      case AnalogAlarmState.alarming:
        return Icon(Icons.notifications,
            color: Theme.of(context).colorScheme.error);

      case AnalogAlarmState.bypassed:
        return const Icon(Icons.notifications_off);

      case AnalogAlarmState.notAlarming:
        return Container();
    }
  }
}
