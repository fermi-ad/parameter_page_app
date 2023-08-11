import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/util.dart';

import '../services/dpm/dpm_service.dart';

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
    return wide ? _buildWide(context) : _buildNarrow(context);
  }

  Widget _buildNarrow(BuildContext context) {
    return Row(
        key: Key("parameter_basicstatus_$drf"),
        children: _buildBasicStatusWidgets());
  }

  Widget _buildWide(BuildContext context) {
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
          wide
              ? Expanded(
                  child: Text(withLabel,
                      style: labelsStyle, textAlign: TextAlign.right))
              : Container(),
          SizedBox(width: 8.0, child: Text(withCharacter, style: valueStyle))
        ]);
  }

  static const _fontSize = 12.0;
}
