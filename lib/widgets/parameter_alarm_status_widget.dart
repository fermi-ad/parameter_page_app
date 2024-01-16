import 'package:flutter/material.dart';
import 'package:flutter_controls_core/service/acsys/service.dart';

class ParameterAlarmStatusWidget extends StatelessWidget {
  static const iconSize = 16.0;

  final AnalogAlarmStatus status;

  const ParameterAlarmStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
        child: _buildIcon(context));
  }

  _buildIcon(BuildContext context) {
    switch (status.state) {
      case AnalogAlarmState.alarming:
        return Icon(Icons.notifications,
            color: Theme.of(context).colorScheme.error, size: iconSize);

      case AnalogAlarmState.bypassed:
        return const Icon(Icons.notifications_off, size: iconSize);

      case AnalogAlarmState.notAlarming:
        return const SizedBox(width: iconSize);
    }
  }
}
