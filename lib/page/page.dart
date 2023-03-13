import 'package:flutter/material.dart';

class ParamInfo {
  final String drf;
  final String description;
  final double? setting = 50.0;
  final String settingUnits = "mm";
  final double reading = 99.0;
  final String readingUnits = "mm";

  const ParamInfo(this.drf, this.description);
}

class PageWidget extends StatelessWidget {
  final List<ParamInfo> parameters;

  const PageWidget(this.parameters, {super.key});

  Widget buildParam(double? value, String units) {
    return value == null
        ? Container()
        : Row(children: [Text(textAlign: TextAlign.end, "$value $units")]);
  }

  Widget buildRow(BuildContext buildContext, ParamInfo param) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(key: Key("parameter_row_${param.drf}"), children: [
        Expanded(
            flex: 3,
            child: Tooltip(
                message: param.drf,
                child: Text(overflow: TextOverflow.ellipsis, param.drf))),
        Expanded(
            flex: 5,
            child: Text(overflow: TextOverflow.ellipsis, param.description)),
        buildParam(param.setting, param.settingUnits),
        buildParam(param.reading, param.readingUnits)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
            children: parameters.map((e) => buildRow(context, e)).toList()));
  }
}
