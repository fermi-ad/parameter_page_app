import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/widgets/util.dart';

class ParameterBasicStatusWidget extends StatelessWidget {
  final DigitalStatus digitalStatus;
  final String drf;
  final bool wide;

  const ParameterBasicStatusWidget(
      {super.key,
      required this.drf,
      required this.digitalStatus,
      this.wide = true});

  @override
  Widget build(BuildContext context) {
    return Column(
        key: Key("parameter_basicstatus_$drf"),
        crossAxisAlignment: CrossAxisAlignment.end,
        children: _buildBasicStatusWidgets());
  }

  List<Widget> _buildBasicStatusWidgets() {
    List<Widget> statusWidgets = List<Widget>.empty(growable: true);

    if (digitalStatus.onOff != null) {
      statusWidgets.add(_buildRow(
          forProperty: "onoff",
          withLabel: "On/Off: ",
          withCharacter: digitalStatus.onOff!.character,
          withColor: digitalStatus.onOff!.color));
    }

    if (digitalStatus.readyTripped != null) {
      statusWidgets.add(_buildRow(
          forProperty: "readytripped",
          withLabel: "Ready/Tripped: ",
          withCharacter: digitalStatus.readyTripped!.character,
          withColor: digitalStatus.readyTripped!.color));
    }

    if (digitalStatus.remoteLocal != null) {
      statusWidgets.add(_buildRow(
          forProperty: "remotelocal",
          withLabel: "Remote/Local: ",
          withCharacter: digitalStatus.remoteLocal!.character,
          withColor: digitalStatus.remoteLocal!.color));
    }

    if (digitalStatus.positiveNegative != null) {
      statusWidgets.add(_buildRow(
          forProperty: "positivenegative",
          withLabel: "Positive/Negative: ",
          withCharacter: digitalStatus.positiveNegative!.character,
          withColor: digitalStatus.positiveNegative!.color));
    }

    return statusWidgets;
  }

  Row _buildRow(
      {required String forProperty,
      required String withLabel,
      required String withCharacter,
      required StatusColor withColor}) {
    const labelsStyle = TextStyle(color: Colors.grey, fontSize: _fontSize);
    final valueStyle =
        TextStyle(color: Util.mapColor(from: withColor), fontSize: _fontSize);

    return Row(
        key: Key("parameter_basicstatus_${forProperty}_$drf"),
        children: [
          Expanded(
              child: Text(withLabel,
                  style: labelsStyle, textAlign: TextAlign.right)),
          SizedBox(width: 8.0, child: Text(withCharacter, style: valueStyle))
        ]);
  }

  static const _fontSize = 12.0;
}
