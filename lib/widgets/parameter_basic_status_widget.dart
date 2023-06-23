import 'package:flutter/material.dart';

import '../dpm_service.dart';

class ParameterBasicStatusWidget extends StatelessWidget {
  final DigitalStatus digitalStatus;
  final String drf;

  const ParameterBasicStatusWidget(
      {super.key, required this.drf, required this.digitalStatus});

  @override
  Widget build(BuildContext context) {
    const fontSize = 12.0
    const labelsStyle = TextStyle(color: Colors.grey, fontSize: fontSize);

    List<Row> digitalStatusRows = List<Row>.empty(growable: true);

    if (digitalStatus.onOff != null) {
      final onOffValueStyle = TextStyle(
          color: _convertToColor(fromStatusColor: digitalStatus.onOff!.color),
          fontSize: fontSize);

      digitalStatusRows
          .add(Row(key: Key("parameter_basicstatus_onoff_$drf"), children: [
        const Text("On/Off: ", style: labelsStyle, textAlign: TextAlign.right),
        Text(digitalStatus.onOff!.character, style: onOffValueStyle)
      ]));
    }

    if (digitalStatus.readyTripped != null) {
      final readyTrippedValueStyle = TextStyle(
          color: _convertToColor(
              fromStatusColor: digitalStatus.readyTripped!.color),
          fontSize: fontSize);

      digitalStatusRows.add(
          Row(key: Key("parameter_basicstatus_readytripped_$drf"), children: [
        const Text("Ready/Tripped: ",
            style: labelsStyle, textAlign: TextAlign.right),
        Text(digitalStatus.readyTripped!.character,
            style: readyTrippedValueStyle)
      ]));
    }

    if (digitalStatus.remoteLocal != null) {
      final remoteLocalValueStyle = TextStyle(
          color: _convertToColor(
              fromStatusColor: digitalStatus.remoteLocal!.color),
          fontSize: fontSize);

      digitalStatusRows.add(
          Row(key: Key("parameter_basicstatus_remotelocal_$drf"), children: [
        const Text("Remote/Local: ",
            style: labelsStyle, textAlign: TextAlign.right),
        Text(digitalStatus.remoteLocal!.character, style: remoteLocalValueStyle)
      ]));
    }

    if (digitalStatus.positiveNegative != null) {
      final positiveNegativeValueStyle = TextStyle(
          color: _convertToColor(
              fromStatusColor: digitalStatus.positiveNegative!.color),
          fontSize: fontSize);

      digitalStatusRows.add(Row(
          key: Key("parameter_basicstatus_positivenegative_$drf"),
          children: [
            const Text("Positive/Negative: ",
                style: labelsStyle, textAlign: TextAlign.right),
            Text(digitalStatus.positiveNegative!.character,
                style: positiveNegativeValueStyle)
          ]));
    }

    return Column(
        key: Key("parameter_basicstatus_$drf"), children: digitalStatusRows);
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
}
