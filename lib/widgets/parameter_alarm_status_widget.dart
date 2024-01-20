import 'package:flutter/material.dart';
import 'package:flutter_controls_core/service/acsys/service.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

class ParameterAlarmStatusWidget extends StatelessWidget {
  static const iconSize = 16.0;

  final AnalogAlarmState alarmState;

  final String drf;

  const ParameterAlarmStatusWidget(
      {super.key, required this.alarmState, required this.drf});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
        child: _buildAlarmActionsMenu(context));
  }

  PopupMenuButton _buildAlarmActionsMenu(BuildContext context) {
    return PopupMenuButton(
        key: Key("parameter_analogalarm_$drf"),
        enabled: true,
        icon: _buildIcon(context),
        onSelected: (item) => _handleMenuSelection(item, context),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                  value: "Enable Alarm",
                  enabled: alarmState == AnalogAlarmState.bypassed,
                  child: const Text("Enable Alarm")),
              PopupMenuItem<String>(
                  value: "By-pass Alarm",
                  enabled: alarmState != AnalogAlarmState.bypassed,
                  child: const Text("By-pass Alarm")),
            ]);
  }

  _buildIcon(BuildContext context) {
    switch (alarmState) {
      case AnalogAlarmState.alarming:
        return Tooltip(
            message: "Alarming",
            child: Icon(Icons.notifications_active,
                color: Theme.of(context).colorScheme.error, size: iconSize));

      case AnalogAlarmState.bypassed:
        return Tooltip(
            message: "Alarm by-passed",
            child: Icon(Icons.notifications_off,
                size: iconSize, color: Theme.of(context).colorScheme.primary));

      case AnalogAlarmState.notAlarming:
        return Tooltip(
            message: "Not alarming",
            child: Icon(Icons.notifications,
                size: iconSize,
                color: Theme.of(context).colorScheme.onPrimary));
    }
  }

  void _handleMenuSelection(String item, BuildContext context) {
    if (item == "By-pass Alarm") {
      _handleBypass(context);
    } else if (item == "Enable Alarm") {
      _handleEnable(context);
    }
  }

  void _handleEnable(BuildContext context) {
    final DataAcquisitionWidget daqWidget = DataAcquisitionWidget.of(context);
    daqWidget.submit(forDRF: "$drf.ANALOG.ENABLE", newSetting: "1");
  }

  void _handleBypass(BuildContext context) {
    final DataAcquisitionWidget daqWidget = DataAcquisitionWidget.of(context);
    daqWidget.submit(forDRF: "$drf.ANALOG.ENABLE", newSetting: "0");
  }
}
