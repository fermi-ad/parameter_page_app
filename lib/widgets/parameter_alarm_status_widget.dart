import 'package:flutter/material.dart';
import 'package:flutter_controls_core/service/acsys/service.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

class ParameterAlarmStatusWidget extends StatelessWidget {
  static const iconSize = 16.0;

  final AnalogAlarmStatus status;

  final String drf;

  const ParameterAlarmStatusWidget(
      {super.key, required this.status, required this.drf});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
        child: _buildAlarmActionsMenu(context));
  }

  PopupMenuButton _buildAlarmActionsMenu(BuildContext context) {
    return PopupMenuButton(
        key: Key("parameter_analogalarm_$drf"),
        icon: _buildIcon(context),
        onSelected: (item) => _handleMenuSelection(item, context),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                  value: "Enable Alarm", child: Text("Enable Alarm")),
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
