import 'package:flutter/material.dart';

import '../dpm_service.dart';

class ParameterBasicStatusWidget extends StatelessWidget {
  final DigitalStatus digitalStatus;
  final String drf;

  const ParameterBasicStatusWidget(
      {super.key, required this.drf, required this.digitalStatus});

  @override
  Widget build(BuildContext context) {
    List<Row> digitalStatusRows = List<Row>.empty(growable: true);

    if (digitalStatus.onOff != null) {
      digitalStatusRows.add(_buildRow(
          forProperty: "onoff",
          withLabel: "On/Off: ",
          withCharacter: digitalStatus.onOff!.character,
          withColor: digitalStatus.onOff!.color));
    }

    if (digitalStatus.readyTripped != null) {
      digitalStatusRows.add(_buildRow(
          forProperty: "readytripped",
          withLabel: "Ready/Tripped: ",
          withCharacter: digitalStatus.readyTripped!.character,
          withColor: digitalStatus.readyTripped!.color));
    }

    if (digitalStatus.remoteLocal != null) {
      digitalStatusRows.add(_buildRow(
          forProperty: "remotelocal",
          withLabel: "Remote/Local: ",
          withCharacter: digitalStatus.remoteLocal!.character,
          withColor: digitalStatus.remoteLocal!.color));
    }

    if (digitalStatus.positiveNegative != null) {
      digitalStatusRows.add(_buildRow(
          forProperty: "positivenegative",
          withLabel: "Positive/Negative: ",
          withCharacter: digitalStatus.positiveNegative!.character,
          withColor: digitalStatus.positiveNegative!.color));
    }

    return Column(
        key: Key("parameter_basicstatus_$drf"), children: digitalStatusRows);
  }

  Row _buildRow(
      {required String forProperty,
      required String withLabel,
      required String withCharacter,
      required StatusColor withColor}) {
    const labelsStyle = TextStyle(color: Colors.grey, fontSize: _fontSize);
    final valueStyle = TextStyle(
        color: _convertToColor(fromStatusColor: withColor),
        fontSize: _fontSize);

    return Row(
        key: Key("parameter_basicstatus_${forProperty}_$drf"),
        children: [
          Text(withLabel, style: labelsStyle, textAlign: TextAlign.right),
          Text(withCharacter, style: valueStyle)
        ]);
  }

  Color _convertToColor({required StatusColor fromStatusColor}) {
    switch (fromStatusColor) {
      case StatusColor.black:
        return Colors.black;
      case StatusColor.blue:
        return Colors.blue;
      case StatusColor.cyan:
        return Colors.cyan;
      case StatusColor.green:
        return Colors.green;
      case StatusColor.magenta:
        return Colors.pink;
      case StatusColor.red:
        return Colors.red;
      case StatusColor.white:
        return Colors.white;
      case StatusColor.yellow:
        return Colors.yellow;
    }
  }

  static const _fontSize = 12.0;
}
