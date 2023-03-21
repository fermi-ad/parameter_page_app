import 'package:flutter/material.dart';

// Base class for the Entry class hierarchy.

abstract class PageEntry {
  final Key key;

  // The base class takes an optional 'key' parameter. If it
  // isn't provided a key, it'll use `UniqueKey()`.

  PageEntry({Key? key}) : key = key ?? UniqueKey();

  Widget buildEntry(BuildContext context, bool editMode, bool wide);
}

class CommentEntry extends PageEntry {
  final String text;

  CommentEntry(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildEntry(BuildContext context, bool editMode, bool wide) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
      child: Text(text, style: const TextStyle(color: Colors.cyan)),
    );
  }
}

class ParameterEntry extends PageEntry {
  final String drf;
  final String? label;

  ParameterEntry(this.drf, {this.label, Key? key}) : super(key: key);

  @override
  Widget buildEntry(BuildContext context, bool editMode, bool wide) {
    return _ParameterWidget(drf, editMode, wide,
        label: label, key: Key("parameter_row_$drf"));
  }
}

class _ParameterWidget extends StatefulWidget {
  final String drf;
  final String? label;
  final bool editMode;
  final bool wide;

  const _ParameterWidget(this.drf, this.editMode, this.wide,
      {this.label, super.key});

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
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36.0),
        child: Text(overflow: TextOverflow.ellipsis, widget.drf));
  }

  Widget buildRunner(BuildContext context) {
    return widget.wide
        ? ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 34.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Tooltip(
                        message: widget.drf,
                        child: Text(
                            overflow: TextOverflow.ellipsis,
                            widget.label ?? widget.drf))),
                Expanded(
                    child: Text(
                        overflow: TextOverflow.ellipsis, description ?? "")),
                Row(
                  children: [
                    _buildParam(setting, settingUnits),
                    const SizedBox(width: 12.0),
                    _buildParam(reading, readingUnits)
                  ],
                ),
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Tooltip(
                  message: widget.drf,
                  child: Text(
                      overflow: TextOverflow.ellipsis,
                      widget.label ?? widget.drf)),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                    overflow: TextOverflow.ellipsis,
                    description ?? "",
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontStyle: FontStyle.italic, color: Colors.grey)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _buildParam(setting, settingUnits),
                _buildParam(reading, readingUnits)
              ]),
            ]),
          );
  }

  @override
  Widget build(BuildContext context) {
    return widget.editMode ? buildEditor(context) : buildRunner(context);
  }
}
