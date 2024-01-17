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
        child: _buildAlarmActionsMenu(context));
  }

  PopupMenuButton _buildAlarmActionsMenu(BuildContext context) {
    return PopupMenuButton(
        icon: _buildIcon(context),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                  value: "By-pass Alarm", child: Text("By-pass Alarm")),
            ]);
  }

  _buildIcon(BuildContext context) {
    switch (status.state) {
      case AnalogAlarmState.alarming:
        return Icon(Icons.notifications_active,
            color: Theme.of(context).colorScheme.error, size: iconSize);

      case AnalogAlarmState.bypassed:
        return Icon(Icons.notifications_off,
            size: iconSize, color: Theme.of(context).colorScheme.primary);

      case AnalogAlarmState.notAlarming:
        return Icon(Icons.notifications,
            size: iconSize, color: Theme.of(context).colorScheme.onPrimary);
    }
  }
}
