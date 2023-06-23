import 'package:flutter/material.dart';

import '../dpm_service.dart';

class ParameterBasicStatusWidget extends StatelessWidget {
  final DigitalStatus digitalStatus;
  final String drf;

  const ParameterBasicStatusWidget(
      {super.key, required this.drf, required this.digitalStatus});

  @override
  Widget build(BuildContext context) {
    const labelsStyle = TextStyle(color: Colors.grey, fontSize: 12.0);
    const onOffValueStyle = TextStyle(color: Colors.green, fontSize: 12.0);
    const readyTrippedValueStyle = TextStyle(color: Colors.red, fontSize: 12.0);
    const remoteLocalValueStyle = TextStyle(color: Colors.blue, fontSize: 12.0);
    const positiveNegativeValueStyle =
        TextStyle(color: Colors.pink, fontSize: 12.0);

    List<Row> digitalStatusRows = List<Row>.empty(growable: true);

    if (digitalStatus.onOff != null) {
      digitalStatusRows
          .add(Row(key: Key("parameter_basicstatus_onoff_$drf"), children: [
        const Text("On/Off: ", style: labelsStyle, textAlign: TextAlign.right),
        Text(digitalStatus.onOff!.character, style: onOffValueStyle)
      ]));
    }

    if (digitalStatus.readyTripped != null) {
      digitalStatusRows.add(
          Row(key: Key("parameter_basicstatus_readytripped_$drf"), children: [
        const Text("Ready/Tripped: ",
            style: labelsStyle, textAlign: TextAlign.right),
        Text(digitalStatus.readyTripped!.character,
            style: readyTrippedValueStyle)
      ]));
    }

    if (digitalStatus.remoteLocal != null) {
      digitalStatusRows.add(
          Row(key: Key("parameter_basicstatus_remotelocal_$drf"), children: [
        const Text("Remote/Local: ",
            style: labelsStyle, textAlign: TextAlign.right),
        Text(digitalStatus.remoteLocal!.character, style: remoteLocalValueStyle)
      ]));
    }

    if (digitalStatus.positiveNegative != null) {
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
}
