import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parameter_page/dpm_service.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

import 'data_acquisition_widget.dart';
import 'display_settings_widget.dart';

class ParameterWidget extends StatelessWidget {
  final String drf;
  final String? label;
  final bool editMode;
  final bool wide;
  final bool displayAlarmDetails;
  final DisplayUnits displayUnits;

  const ParameterWidget(this.drf, this.editMode, this.wide,
      {this.label,
      super.key,
      this.displayUnits = DisplayUnits.commonUnits,
      this.displayAlarmDetails = false});

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
                dpm: DataAcquisitionWidget.of(context),
                displayAlarmDetails: displayAlarmDetails));
  }
}

class _ActiveParamWidget extends StatefulWidget {
  final String drf;
  final DataAcquisitionWidget dpm;
  final bool wide;
  final DisplayUnits displayUnits;
  final bool displayAlarmDetails;

  const _ActiveParamWidget(
      {required this.drf,
      required this.dpm,
      required this.wide,
      required this.displayUnits,
      required this.displayAlarmDetails});

  @override
  _ActiveParamState createState() => _ActiveParamState();
}

class _ActiveParamState extends State<_ActiveParamWidget> {
  late final Future<List<DeviceInfo>> _setup;
  String? description;
  String? units;

  @override
  void initState() {
    _setup = widget.dpm.getDeviceInfo([widget.drf]);

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
            Expanded(
                flex: 4,
                child: Visibility(
                    visible: widget.displayAlarmDetails,
                    child: Row(children: [
                      Text(
                          key: Key("parameter_alarm_nominal_${widget.drf}"),
                          "Nominal"),
                      const Spacer(),
                      Text(
                          key: Key("parameter_alarm_tolerance_${widget.drf}"),
                          "Tolerance")
                    ]))),
            const Spacer(),
            Row(
              children: [
                _buildParam(_settingValue, _settingUnits,
                    key: Key("parameter_setting_${widget.drf}")),
                const SizedBox(width: 12.0),
                StreamBuilder(
                    stream: widget.dpm.monitorDevices([widget.drf]),
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
              stream: widget.dpm.monitorDevices([widget.drf]),
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
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return from.data!.value.toStringAsPrecision(4);
      case DisplayUnits.primaryUnits:
        return from.data!.primaryValue.toStringAsPrecision(4);
      case DisplayUnits.raw:
        return from.data!.rawValue;
      default:
        AssertionError("Invalid displayUnits!");
        return "Invalid displayUnits!";
    }
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
        units = _extractReadingUnits(from: value);
        return value;
      }),

      // The builder function decides which renderer to call.

      builder: (context, snapshot) {
        return widget.wide ? _buildWide(context) : _buildNarrow(context);
      },
    );
  }

  String _extractReadingUnits({required from}) {
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return from.first.reading.commonUnits;
      case DisplayUnits.primaryUnits:
        return from.first.reading.primaryUnits;
      case DisplayUnits.raw:
        return "";
      default:
        AssertionError("Invalid displayUnits!");
        return "Invalid displayUnits!";
    }
  }

  String get _settingUnits {
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return "mm";
      case DisplayUnits.primaryUnits:
        return "Volt";
      case DisplayUnits.raw:
        return "";
      default:
        AssertionError("Invalid displayUnits!");
        return "Invalid displayUnits!";
    }
  }

  String get _settingValue {
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return "50.0";
      case DisplayUnits.primaryUnits:
        return "5.0";
      case DisplayUnits.raw:
        return "8888";
      default:
        AssertionError("Invalid displayUnits!");
        return "Invalid displayUnits!";
    }
  }
}
