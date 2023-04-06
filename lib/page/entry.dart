import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parameter_page/gql-dpm/dpm_service.dart';

// Base class for the Entry class hierarchy.

abstract class PageEntry {
  final Key key;

  // The base class takes an optional 'key' parameter. If it
  // isn't provided a key, it'll use `UniqueKey()`.

  PageEntry({Key? key}) : key = key ?? UniqueKey();

  Widget buildEntry(BuildContext context, bool editMode, bool wide);
}

class PageEntryWidget extends StatelessWidget {
  final Widget child;

  const PageEntryWidget({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0), child: child);
  }
}

class CommentEntryWidget extends StatelessWidget {
  final String text;

  const CommentEntryWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return PageEntryWidget(
        child: Text(text, style: const TextStyle(color: Colors.cyan)));
  }
}

class CommentEntry extends PageEntry {
  final String text;

  CommentEntry(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildEntry(BuildContext context, bool editMode, bool wide) {
    return CommentEntryWidget(text);
  }
}

class ParameterEntry extends PageEntry {
  final String drf;
  final String? label;

  ParameterEntry(this.drf, {this.label, super.key});

  @override
  Widget buildEntry(BuildContext context, bool editMode, bool wide) {
    return ParameterWidget(drf, editMode, wide, label: label, key: key);
  }
}

class ParameterWidget extends StatelessWidget {
  final String drf;
  final String? label;
  final bool editMode;
  final bool wide;

  const ParameterWidget(this.drf, this.editMode, this.wide,
      {this.label, super.key});

  Widget buildEditor(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36.0),
        child: Text(overflow: TextOverflow.ellipsis, drf));
  }

  @override
  Widget build(BuildContext context) {
    return PageEntryWidget(
        child: editMode
            ? buildEditor(context)
            : _ActiveParamWidget(
                drf: drf, wide: wide, dpm: DpmService.of(context)));
  }
}

class _ActiveParamWidget extends StatefulWidget {
  final String drf;
  final DpmService dpm;
  final bool wide;

  const _ActiveParamWidget(
      {required this.drf, required this.dpm, required this.wide});

  @override
  _ActiveParamState createState() => _ActiveParamState();
}

class _ActiveParamState extends State<_ActiveParamWidget> {
  late final Future<List<DeviceInfo>> _setup;
  late final Stream<Reading> _stream;
  String? description;
  String? units;

  @override
  void initState() {
    _setup = widget.dpm.getDeviceInfo([widget.drf]);
    _stream = widget.dpm.monitorDevices([widget.drf]);
    super.initState();
  }

  Widget _buildParam(double? value, String? units) {
    return value == null
        ? Container()
        : (units == null
            ? Text(textAlign: TextAlign.end, value.toStringAsPrecision(4))
            : Row(children: [
                Text(textAlign: TextAlign.end, value.toStringAsPrecision(4)),
                const SizedBox(width: 6.0),
                Text(units, style: const TextStyle(color: Colors.grey))
              ]));
  }

  Widget _buildWide(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 34.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 3,
                child: Tooltip(
                    message: widget.drf,
                    child: Text(overflow: TextOverflow.ellipsis, widget.drf))),
            Expanded(
                flex: 2,
                child:
                    Text(overflow: TextOverflow.ellipsis, description ?? "")),
            const Spacer(),
            Row(
              children: [
                _buildParam(50.0, "mm"),
                const SizedBox(width: 12.0),
                StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return _buildParam(snapshot.data!.value, units);
                      } else {
                        return _buildParam(null, units);
                      }
                    })
              ],
            ),
          ],
        ));
  }

  Widget _buildNarrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Tooltip(
            message: widget.drf,
            child: Text(overflow: TextOverflow.ellipsis, widget.drf)),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
              overflow: TextOverflow.ellipsis,
              description ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontStyle: FontStyle.italic, color: Colors.grey)),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _buildParam(50.0, units),
          StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return _buildParam(snapshot.data!.value, units);
                } else {
                  return _buildParam(null, units);
                }
              })
        ]),
      ]),
    );
  }

  // Builds the widget.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // The FUtureBuilder monitors our `getDeviceInfo` query. When it
      // completes, we transfer over the values of `description` and `units` so
      // the widgets can display them.

      future: _setup.then((value) {
        description = value.first.description;
        units = value.first.units;
        return value;
      }),

      // The builder function decides which renderer to call.

      builder: (context, snapshot) {
        return widget.wide ? _buildWide(context) : _buildNarrow(context);
      },
    );
  }
}
