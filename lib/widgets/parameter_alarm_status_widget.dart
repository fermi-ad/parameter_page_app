import 'package:flutter/material.dart';
import 'package:flutter_controls_core/service/acsys/service.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

class ParameterAlarmStatusWidget extends StatelessWidget {
  static const iconSize = 16.0;

  final AlarmState alarmState;

  final String drf;

  final bool settingsAllowed;

  const ParameterAlarmStatusWidget(
      {super.key,
      required this.alarmState,
      required this.drf,
      required this.settingsAllowed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
        child: IconButton(
            icon: _buildIcon(context),
            onPressed: settingsAllowed ? () => _handleToggle(context) : null));
  }

  _buildIcon(BuildContext context) {
    switch (alarmState) {
      case AlarmState.alarming:
        return Tooltip(
            message: settingsAllowed
                ? "By-pass Alarm"
                : "Alarming (enable settings to by-pass)",
            child: Icon(Icons.notifications_active,
                color: Theme.of(context).colorScheme.error, size: iconSize));

      case AlarmState.bypassed:
        return Tooltip(
            message: settingsAllowed
                ? "Enable Alarm"
                : "Alarm By-passed (enable settings to enable alarm)",
            child: Icon(Icons.notifications_off,
                size: iconSize, color: Theme.of(context).colorScheme.primary));

      case AlarmState.notAlarming:
        return Tooltip(
            message: settingsAllowed
                ? "By-pass Alarm"
                : "Not Alarming (enable settings to by-pass)",
            child: Icon(Icons.notifications,
                size: iconSize,
                color: Theme.of(context).colorScheme.onPrimary));
    }
  }

  void _handleToggle(BuildContext context) {
    if (alarmState == AlarmState.bypassed) {
      _handleEnable(context);
    } else {
      _handleBypass(context);
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
