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
      const SizedBox(width: 72.0),
      Column(children: _buildRows())
    ]);
  }

  List<Row> _buildRows() {
    List<Row> rows = List<Row>.empty(growable: true);

    if (digitalStatus.extendedStatus != null) {
      for (int i = 0; i < digitalStatus.extendedStatus!.length; i++) {
        final attribute = digitalStatus.extendedStatus![i];
        rows.add(_buildRow(
            bitN: i,
            description: attribute.description,
            valueText: attribute.valueText,
            value: attribute.value,
            valueColor: Util.mapColor(from: attribute.color)));
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
    const labelsStyle = TextStyle(color: Colors.grey, fontSize: 14.0);
    final valueStyle = TextStyle(color: valueColor, fontSize: 14.0);

    return Row(
        key: Key("parameter_extendeddigitalstatus_${drf}_bit$bitN"),
        children: [
          Text(
            "$bitN: ",
            style: labelsStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            description,
            style: labelsStyle,
            textAlign: TextAlign.left,
          ),
          const SizedBox(width: 48.0),
          Text(
            valueText,
            style: valueStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            value,
            style: valueStyle,
            textAlign: TextAlign.left,
          )
        ]);
  }
}
