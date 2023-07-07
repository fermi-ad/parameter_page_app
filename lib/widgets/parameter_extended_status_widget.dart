import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/util.dart';

import '../dpm_service.dart';

class ParameterExtendedStatusWidget extends StatelessWidget {
  final String drf;
  final DigitalStatus digitalStatus;

  const ParameterExtendedStatusWidget(
      {super.key, required this.drf, required this.digitalStatus});
  @override
  Widget build(BuildContext context) {
    return Row(key: Key("parameter_extendeddigitalstatus_$drf"), children: [
      SizedBox(
          width: 400.0,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildRows()))
    ]);
  }

  List<Row> _buildRows() {
    List<Row> rows = List<Row>.empty(growable: true);

    if (digitalStatus.extendedStatus != null) {
      for (int i = 0; i < digitalStatus.extendedStatus!.length; i++) {
        final attribute = digitalStatus.extendedStatus![i];
        rows.add(_buildRow(
            bitN: i,
            description:
                attribute.description != null ? attribute.description! : "...",
            valueText:
                attribute.valueText != null ? attribute.valueText! : "...",
            value: attribute.value,
            valueColor: attribute.color != null
                ? Util.mapColor(from: attribute.color!)
                : Colors.grey));
      }
    }
    return rows;
  }

  Row _buildRow(
      {required int bitN,
      required String description,
      required String valueText,
      required String value,
      required Color valueColor}) {
    const labelsStyle = TextStyle(color: Colors.grey, fontSize: 16.0);
    final valueStyle = TextStyle(color: valueColor, fontSize: 16.0);

    return Row(
        key: Key("parameter_extendeddigitalstatus_${drf}_bit$bitN"),
        children: [
          Text(
            "Bit $bitN: ",
            style: labelsStyle,
            textAlign: TextAlign.left,
          ),
          Expanded(
              flex: 2,
              child: Text(
                description,
                style: labelsStyle,
                textAlign: TextAlign.left,
              )),
          const Spacer(),
          Expanded(
              flex: 1,
              child: Text(
                valueText,
                style: valueStyle,
                textAlign: TextAlign.left,
              )),
          const Spacer(),
          Text(
            value,
            style: valueStyle,
            textAlign: TextAlign.left,
          )
        ]);
  }
}