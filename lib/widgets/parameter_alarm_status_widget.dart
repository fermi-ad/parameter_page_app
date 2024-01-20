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
        child: IconButton(
            icon: _buildIcon(context),
            onPressed: () => _handleToggle(context)));
  }

  _buildIcon(BuildContext context) {
    switch (alarmState) {
      case AnalogAlarmState.alarming:
        return Tooltip(
            message: "By-pass Alarm",
            child: Icon(Icons.notifications_active,
                color: Theme.of(context).colorScheme.error, size: iconSize));

      case AnalogAlarmState.bypassed:
        return Tooltip(
            message: "Enable Alarm",
            child: Icon(Icons.notifications_off,
                size: iconSize, color: Theme.of(context).colorScheme.primary));

      case AnalogAlarmState.notAlarming:
        return Tooltip(
            message: "By-pass Alarm",
            child: Icon(Icons.notifications,
                size: iconSize,
                color: Theme.of(context).colorScheme.onPrimary));
    }
  }

  void _handleToggle(BuildContext context) {
    if (alarmState == AnalogAlarmState.bypassed) {
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
