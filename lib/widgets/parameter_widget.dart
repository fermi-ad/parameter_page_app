import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parameter_page/dpm_service.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';
import 'package:parameter_page/widgets/parameter_basic_status_widget.dart';

import 'data_acquisition_widget.dart';
import 'display_settings_widget.dart';
import 'parameter_alarm_details_widget.dart';

class ParameterWidget extends StatelessWidget {
  final String drf;
  final String? label;
  final bool editMode;
  final bool wide;
  final bool displayAlarmDetails;
  final DisplayUnits displayUnits;
  final bool displayExtendedStatus;

  const ParameterWidget(
      {required this.drf,
      required this.editMode,
      required this.wide,
      this.label,
      super.key,
      this.displayUnits = DisplayUnits.commonUnits,
      this.displayAlarmDetails = false,
      this.displayExtendedStatus = false});

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
                displayAlarmDetails: displayAlarmDetails,
                displayExtendedStatus: displayExtendedStatus));
  }
}

class _ActiveParamWidget extends StatefulWidget {
  final String drf;
  final DataAcquisitionWidget dpm;
  final bool wide;
  final DisplayUnits displayUnits;
  final bool displayAlarmDetails;
  final bool displayExtendedStatus;

  const _ActiveParamWidget(
      {required this.drf,
      required this.dpm,
      required this.wide,
      required this.displayUnits,
      required this.displayAlarmDetails,
      required this.displayExtendedStatus});

  @override
  _ActiveParamState createState() => _ActiveParamState();
}

class _ActiveParamState extends State<_ActiveParamWidget> {
  late final Future<List<DeviceInfo>> _setup;
  DeviceInfo? info;
  bool _displayExtendedStatus = false;

  String? get readingUnits {
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return info?.reading?.commonUnits;
      case DisplayUnits.primaryUnits:
        return info?.reading?.primaryUnits;
      case DisplayUnits.raw:
        return null;
    }
  }

  String? get settingUnits {
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return info?.setting?.commonUnits;
      case DisplayUnits.primaryUnits:
        return info?.setting?.primaryUnits;
      case DisplayUnits.raw:
        return null;
    }
  }

  @override
  void initState() {
    _setup = widget.dpm.getDeviceInfo([widget.drf]);

    super.initState();
    _displayExtendedStatus = widget.displayExtendedStatus;
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
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _buildExpandButton(),
            Expanded(
                flex: 2,
                child: Tooltip(
                    message: widget.drf,
                    child: Text(overflow: TextOverflow.ellipsis, widget.drf))),
            Expanded(
                flex: 2,
                child: info != null
                    ? Text(
                        key: Key("parameter_description_${widget.drf}"),
                        overflow: TextOverflow.ellipsis,
                        info!.description)
                    : Container()),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _buildParam(_settingValue, settingUnits,
                    key: Key("parameter_setting_${widget.drf}")),
                const SizedBox(width: 12.0),
                StreamBuilder(
                    stream: widget.dpm.monitorDevices([widget.drf]),
                    builder: _readingBuilder),
                const SizedBox(width: 12.0),
                StreamBuilder(
                    stream:
                        widget.dpm.monitorDigitalStatusDevices([widget.drf]),
                    builder: _basicStatusBuilder)
              ]),
              Visibility(
                  visible: widget.displayAlarmDetails,
                  child: (info != null && info!.alarm != null)
                      ? ParameterAlarmDetailsWidget(
                          drf: widget.drf, alarmBlock: info!.alarm!)
                      : Container()),
            ])
          ]),
          _displayExtendedStatus ? _buildExtendedStatus() : Container()
        ]));
  }

  Widget _buildExpandButton() {
    return (info == null || info!.basicStatus == null)
        ? const SizedBox(width: 48.0)
        : _displayExtendedStatus
            ? IconButton(
                key: Key("parameter_collapsedigitalstatus_${widget.drf}"),
                icon: const Icon(Icons.expand_less),
                onPressed: _toggleDigitalStatus)
            : IconButton(
                key: Key("parameter_expanddigitalstatus_${widget.drf}"),
                icon: const Icon(Icons.expand_more),
                onPressed: _toggleDigitalStatus);
  }

  Widget _buildExtendedStatus() {
    const labelsStyle = TextStyle(color: Colors.grey, fontSize: 14.0);
    const valueStyle = TextStyle(color: Colors.green, fontSize: 14.0);
    const blueStyle = TextStyle(color: Colors.blue, fontSize: 14.0);
    const redStyle = TextStyle(color: Colors.red, fontSize: 14.0);

    return Row(
        key: Key("parameter_extendeddigitalstatus_${widget.drf}"),
        children: [
          const SizedBox(width: 72.0),
          Column(children: [
            Row(
                key: Key("parameter_extendeddigitalstatus_${widget.drf}_bit0"),
                children: const [
                  Text(
                    "0: ",
                    style: labelsStyle,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Henk On/Off",
                    style: labelsStyle,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 48.0),
                  Text(
                    "On",
                    style: valueStyle,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    "1",
                    style: valueStyle,
                    textAlign: TextAlign.left,
                  )
                ]),
            Row(
                key: Key("parameter_extendeddigitalstatus_${widget.drf}_bit1"),
                children: const [
                  Text("1: ", style: labelsStyle),
                  Text("Ready???", style: labelsStyle),
                  Text("Always", style: valueStyle),
                  Text("1", style: valueStyle)
                ]),
            Row(
                key: Key("parameter_extendeddigitalstatus_${widget.drf}_bit2"),
                children: const [
                  Text("2: ", style: labelsStyle),
                  Text("Remote Henk", style: labelsStyle),
                  Text("L", style: blueStyle),
                  Text("0", style: blueStyle)
                ]),
            Row(
                key: Key("parameter_extendeddigitalstatus_${widget.drf}_bit3"),
                children: const [
                  Text("3: ", style: labelsStyle),
                  Text("Polarity", style: labelsStyle),
                  Text("Mono", style: redStyle),
                  Text("0", style: redStyle)
                ]),
            Row(
                key: Key("parameter_extendeddigitalstatus_${widget.drf}_bit4"),
                children: const [
                  Text("4: ", style: labelsStyle),
                  Text(" test 2", style: labelsStyle),
                  Text(" good", style: valueStyle),
                  Text("0", style: valueStyle)
                ]),
            Row(
                key: Key("parameter_extendeddigitalstatus_${widget.drf}_bit5"),
                children: const [
                  Text("5: ", style: labelsStyle),
                  Text("testtest", style: labelsStyle),
                  Text("GOOD", style: valueStyle),
                  Text("0", style: valueStyle)
                ]),
          ])
        ]);
  }

  void _toggleDigitalStatus() {
    setState(() => _displayExtendedStatus = !_displayExtendedStatus);
  }

  Widget _readingBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      return _buildParam(_extractValueString(from: snapshot), readingUnits,
          key: Key("parameter_reading_${widget.drf}"));
    } else {
      return _buildParam(null, readingUnits,
          key: Key("parameter_nullreading_${widget.drf}"));
    }
  }

  Widget _basicStatusBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      return ParameterBasicStatusWidget(
          drf: widget.drf, digitalStatus: snapshot.data!);
    } else {
      return Container();
    }
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
              key: Key("parameter_description_${widget.drf}"),
              overflow: TextOverflow.ellipsis,
              info?.description ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontStyle: FontStyle.italic, color: Colors.grey)),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _buildParam(_settingValue, settingUnits,
                key: Key("parameter_setting_${widget.drf}")),
            StreamBuilder(
                stream: widget.dpm.monitorDevices([widget.drf]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return _buildParam(
                        _extractValueString(from: snapshot), readingUnits,
                        key: Key("parameter_reading_${widget.drf}"));
                  } else {
                    return _buildParam(null, readingUnits,
                        key: Key("parameter_nullreading_${widget.drf}"));
                  }
                })
          ]),
          Visibility(
              visible: widget.displayAlarmDetails,
              child: (info != null && info!.alarm != null)
                  ? ParameterAlarmDetailsWidget(
                      drf: widget.drf, alarmBlock: info!.alarm!)
                  : Container()),
        ])
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
    }
  }

  // Builds the widget.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // The FutureBuilder monitors our `getDeviceInfo` query. When it
      // completes, we save the information.

      future: _setup.then((value) {
        info = value.first;
        return value;
      }),

      // The builder function decides which renderer to call.

      builder: (context, snapshot) {
        return widget.wide ? _buildWide(context) : _buildNarrow(context);
      },
    );
  }

  String get _settingValue {
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return "50.0";
      case DisplayUnits.primaryUnits:
        return "5.0";
      case DisplayUnits.raw:
        return "8888";
    }
  }
}
