import 'package:flutter/material.dart';

// Base class for the Entry class hierarchy.

abstract class PageEntry {
  final Key key;

  // The base class takes an optional 'key' parameter. If it
  // isn't provided a key, it'll use `UniqueKey()`.

  PageEntry({Key? key}) : key = key ?? UniqueKey();

  Widget buildEntry(BuildContext context, bool editMode);
}

class CommentEntry extends PageEntry {
  final String text;

  CommentEntry(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildEntry(BuildContext context, bool editMode) {
    return Row(children: [
      Expanded(child: Text(text, style: const TextStyle(color: Colors.cyan)))
    ]);
  }
}

class ParameterEntry extends PageEntry {
  final String drf;

  ParameterEntry(this.drf, {Key? key}) : super(key: key);

  @override
  Widget buildEntry(BuildContext context, bool editMode) {
    return _ParameterWidget(drf, editMode, key: Key("parameter_row_$drf"));
  }
}

class _ParameterWidget extends StatefulWidget {
  final String drf;
  final bool editMode;

  const _ParameterWidget(this.drf, this.editMode, {super.key});

  @override
  _ParameterEntryState createState() => _ParameterEntryState();
}

class _ParameterEntryState extends State<_ParameterWidget> {
  String? description = "device description";
  double? setting = 50.0;
  String? settingUnits = "mm";
  double? reading = 99.0;
  String? readingUnits = "mm";

  Widget _buildParam(double? value, String? units) {
    return value == null
        ? Container()
        : (units == null
            ? Text(textAlign: TextAlign.end, "$value")
            : Row(children: [
                Text(textAlign: TextAlign.end, "$value"),
                const SizedBox(width: 6.0),
                Text(units, style: const TextStyle(color: Colors.grey))
              ]));
  }

  Widget buildEditor(BuildContext context) {
    return Text(overflow: TextOverflow.ellipsis, widget.drf);
  }

  Widget buildRunner(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Tooltip(
                message: widget.drf,
                child: Text(overflow: TextOverflow.ellipsis, widget.drf))),
        Expanded(
            child: Text(overflow: TextOverflow.ellipsis, description ?? "")),
        Row(
          children: [
            _buildParam(setting, settingUnits),
            const SizedBox(width: 12.0),
            _buildParam(reading, readingUnits)
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.editMode ? buildEditor(context) : buildRunner(context);
  }
}
