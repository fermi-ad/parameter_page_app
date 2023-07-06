import 'package:flutter/material.dart';

import '../dpm_service.dart';

class ParameterExtendedStatusWidget extends StatelessWidget {
  final String drf;
  final DigitalStatus digitalStatus;

  const ParameterExtendedStatusWidget(
      {super.key, required this.drf, required this.digitalStatus});
  @override
  Widget build(BuildContext context) {
    const labelsStyle = TextStyle(color: Colors.grey, fontSize: 14.0);
    const valueStyle = TextStyle(color: Colors.green, fontSize: 14.0);
    const blueStyle = TextStyle(color: Colors.blue, fontSize: 14.0);
    const redStyle = TextStyle(color: Colors.red, fontSize: 14.0);

    return Row(key: Key("parameter_extendeddigitalstatus_$drf"), children: [
      const SizedBox(width: 72.0),
      Column(children: [
        Row(
            key: Key("parameter_extendeddigitalstatus_${drf}_bit0"),
            children: const [
              Text(
                "0: ",
                style: labelsStyle,
                textAlign: TextAlign.left,
              ),
              Text(
                "Henk On/Off",
                style: labelsStyle,
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 48.0),
              Text(
                "On",
                style: valueStyle,
                textAlign: TextAlign.left,
              ),
              SizedBox(width: 8.0),
              Text(
                "1",
                style: valueStyle,
                textAlign: TextAlign.left,
              )
            ]),
        Row(
            key: Key("parameter_extendeddigitalstatus_${drf}_bit1"),
            children: const [
              Text("1: ", style: labelsStyle),
              Text("Ready???", style: labelsStyle),
              Text("Always", style: valueStyle),
              Text("1", style: valueStyle)
            ]),
        Row(
            key: Key("parameter_extendeddigitalstatus_${drf}_bit2"),
            children: const [
              Text("2: ", style: labelsStyle),
              Text("Remote Henk", style: labelsStyle),
              Text("L", style: blueStyle),
              Text("0", style: blueStyle)
            ]),
        Row(
            key: Key("parameter_extendeddigitalstatus_${drf}_bit3"),
            children: const [
              Text("3: ", style: labelsStyle),
              Text("Polarity", style: labelsStyle),
              Text("Mono", style: redStyle),
              Text("0", style: redStyle)
            ]),
        Row(
            key: Key("parameter_extendeddigitalstatus_${drf}_bit4"),
            children: const [
              Text("4: ", style: labelsStyle),
              Text(" test 2", style: labelsStyle),
              Text(" good", style: valueStyle),
              Text("0", style: valueStyle)
            ]),
        Row(
            key: Key("parameter_extendeddigitalstatus_${drf}_bit5"),
            children: const [
              Text("5: ", style: labelsStyle),
              Text("testtest", style: labelsStyle),
              Text("GOOD", style: valueStyle),
              Text("0", style: valueStyle)
            ]),
      ])
    ]);
  }
}
