import 'package:flutter/material.dart';

// Base class for the Entry class hierarchy.

abstract class PageEntry {
  final Key key;

  // The base class takes an optional 'key' parameter. If it
  // isn't provided a key, it'll use `UniqueKey()`.

  PageEntry({Key? key}) : key = key ?? UniqueKey();

  Widget buildEntry(BuildContext context);
}

class CommentEntry extends PageEntry {
  final String text;

  CommentEntry(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildEntry(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(text, style: const TextStyle(color: Colors.cyan)))
    ]);
  }
}

class ParameterEntry extends PageEntry {
  final String drf;

  ParameterEntry(this.drf, {Key? key}) : super(key: key);

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
