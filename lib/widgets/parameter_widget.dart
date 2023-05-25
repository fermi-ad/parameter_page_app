import 'package:flutter/material.dart';
import 'package:parameter_page/dpm_service.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

import 'data_acquisition_widget.dart';

class ParameterWidget extends StatelessWidget {
  final String drf;
  final String? label;
  final bool editMode;
  final bool wide;
  final String displayUnits;

  const ParameterWidget(this.drf, this.editMode, this.wide,
      {this.label, super.key, this.displayUnits = "Common Units"});

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
                displayUnits: displayUnits,
                drf: drf,
                wide: wide,
                dpm: DataAcquisitionWidget.of(context)));
  }
}

class _ActiveParamWidget extends StatefulWidget {
  final String drf;
  final DataAcquisitionWidget dpm;
  final bool wide;
  final String displayUnits;

  const _ActiveParamWidget(
      {required this.drf,
      required this.dpm,
      required this.wide,
      required this.displayUnits});

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

  Widget _buildParam(String? value, String? units, {required Key key}) {
    return value == null
        ? Container()
        : (units == null
            ? Text(key: key, textAlign: TextAlign.end, value)
            : Row(key: key, children: [
                Text(textAlign: TextAlign.end, value),
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
                _buildParam(_settingValue, _settingUnits,
                    key: Key("parameter_setting_${widget.drf}")),
                const SizedBox(width: 12.0),
                StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        return _buildParam(
                            _extractValueString(from: snapshot), units,
                            key: Key("parameter_reading_${widget.drf}"));
                      } else {
                        return _buildParam(null, units,
                            key: Key("parameter_nullreading_${widget.drf}"));
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
          _buildParam(_settingValue, units,
              key: Key("parameter_setting_${widget.drf}")),
          StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  return _buildParam(_extractValueString(from: snapshot), units,
                      key: Key("parameter_reading_${widget.drf}"));
                } else {
                  return _buildParam(null, units,
                      key: Key("parameter_nullreading_${widget.drf}"));
                }
              })
        ]),
      ]),
    );
  }

  String _extractValueString({required from}) {
    if (widget.displayUnits == "Common Units") {
      return from.data!.value.toStringAsPrecision(4);
    } else if (widget.displayUnits == "Primary Units") {
      return from.data!.primaryValue.toStringAsPrecision(4);
    } else if (widget.displayUnits == "Raw") {
      return from.data!.rawValue;
    }

    AssertionError("Invalid displayUnits!");
    return "Invalid displayUnits!";
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
        units = _readingUnits;
        // value.first.units;
        return value;
      }),

      // The builder function decides which renderer to call.

      builder: (context, snapshot) {
        return widget.wide ? _buildWide(context) : _buildNarrow(context);
      },
    );
  }

  String get _readingUnits {
    if (widget.displayUnits == "Common Units") {
      return "degF";
    } else if (widget.displayUnits == "Primary Units") {
      return "Volt";
    } else if (widget.displayUnits == "Raw") {
      return "";
    }

    AssertionError("Invalid displayUnits!");
    return "Invalid displayUnits!";
  }

  String get _settingUnits {
    if (widget.displayUnits == "Common Units") {
      return "mm";
    } else if (widget.displayUnits == "Primary Units") {
      return "Volt";
    } else if (widget.displayUnits == "Raw") {
      return "";
    }

    AssertionError("Invalid displayUnits!");
    return "Invalid displayUnits!";
  }

  String get _settingValue {
    if (widget.displayUnits == "Raw") {
      return "8888";
    } else if (widget.displayUnits == "Primary Units") {
      return "5.0";
    } else {
      return "50.0";
    }
  }
}
