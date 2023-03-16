import 'package:flutter/material.dart';

abstract class PageEntry {
  const PageEntry();

  Widget buildEntry(BuildContext context);
}

class CommentEntry extends PageEntry {
  final String text;

  const CommentEntry(this.text);

  @override
  Widget buildEntry(BuildContext context) {
    return Row(children: [Expanded(child: Text(text))]);
  }
}

class ParameterEntry extends PageEntry {
  final String drf;

  const ParameterEntry(this.drf);

  @override
  Widget buildEntry(BuildContext context) {
    return _ParameterWidget(drf, key: Key("parameter_row_$drf"));
  }
}

class _ParameterWidget extends StatefulWidget {
  final String drf;

  const _ParameterWidget(this.drf, {super.key});

  @override
  _ParameterEntryState createState() => _ParameterEntryState();
}

class _ParameterEntryState extends State<_ParameterWidget> {
  String? description = "device description";
  double? setting = 50.0;
  String? settingUnits = "mm";
  double? reading = 99.0;
  String? readingUnits = "mm";

  Widget _buildParam(double? value, String units) {
    return value == null
        ? Container()
        : Row(children: [Text(textAlign: TextAlign.end, "$value $units")]);
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 3,
          child: Tooltip(
              message: widget.drf,
              child: Text(overflow: TextOverflow.ellipsis, widget.drf))),
      Expanded(
          flex: 5,
          child: Text(overflow: TextOverflow.ellipsis, description ?? "")),
      _buildParam(setting, settingUnits ?? ""),
      _buildParam(reading, readingUnits ?? "")
    ]);
  }
}
