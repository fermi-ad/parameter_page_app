import 'package:flutter/material.dart';
import 'package:parameter_page/dpm_service.dart';
import 'package:parameter_page/widgets/command_button_widget.dart';

class CommandButtonMenuWidget extends StatelessWidget {
  final DeviceInfo deviceInfo;

  final String drf;

  const CommandButtonMenuWidget(
      {super.key, required this.deviceInfo, required this.drf});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
            key: Key("parameter_commands_$drf"), children: _buildButtons()));
  }

  List<Widget> _buildButtons() {
    List<CommandButtonWidget> buttons = [];
    for (DeviceInfoDigitalControl command in deviceInfo.digControl) {
      buttons.add(CommandButtonWidget(
          drf: drf, value: command.value, longName: command.longName));
    }
    return buttons;
  }
}
