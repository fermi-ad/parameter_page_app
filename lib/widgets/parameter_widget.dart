import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parameter_page/services/dpm/dpm_service.dart';
import 'package:parameter_page/widgets/command_menu_widget.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';
import 'package:parameter_page/widgets/parameter_basic_status_widget.dart';
import 'package:parameter_page/widgets/parameter_extended_status_widget.dart';
import 'package:parameter_page/widgets/setting_control_widget.dart';

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
  DeviceInfo? deviceInfo;
  bool _displayExtendedStatus = false;

  bool get hasSettingProperty {
    return deviceInfo?.setting != null;
  }

  bool get hasReadingProperty {
    return deviceInfo?.reading != null;
  }

  String? get readingUnits {
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return deviceInfo?.reading?.commonUnits;
      case DisplayUnits.primaryUnits:
        return deviceInfo?.reading?.primaryUnits;
      case DisplayUnits.raw:
        return null;
    }
  }

  String? get settingUnits {
    switch (widget.displayUnits) {
      case DisplayUnits.commonUnits:
        return deviceInfo?.setting?.commonUnits;
      case DisplayUnits.primaryUnits:
        return deviceInfo?.setting?.primaryUnits;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // The FutureBuilder monitors our `getDeviceInfo` query. When it
      // completes, we save the information.

      future: _setup.then((value) {
        deviceInfo = value.first;
        return value;
      }),

      // The builder function decides which renderer to call.

      builder: (context, snapshot) {
        return widget.wide ? _buildWide(context) : _buildNarrow(context);
      },
    );
  }

  Widget _buildWide(BuildContext context) {
    return Card(
        child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 34.0),
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 40.0),
                child: Column(children: [
                  _buildParameterDetailsRow(),
                  Visibility(
                      visible: _displayExtendedStatus,
                      child: _buildExtendedStatusRow())
                ]))));
  }

  Widget _buildNarrow(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildName(),
        _buildDescription(),
        const SizedBox(height: 10.0),
        Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [Expanded(child: _buildProperties(wide: false))]),
        Visibility(
            visible: _displayExtendedStatus, child: _buildExtendedStatusRow()),
        Row(children: [
          const Spacer(),
          _buildExpandOrCollapseExtendedStatusButton(),
          const Spacer()
        ])
      ]),
    ));
  }

  Widget _buildParameterDetailsRow() {
    return Row(
        key: Key("parameter_row_${widget.drf}"),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: _buildName()),
          Expanded(flex: 2, child: _buildDescription()),
          _buildProperties(wide: true),
          SizedBox(
              width: 32.0, child: _buildExpandOrCollapseExtendedStatusButton()),
        ]);
  }

  Widget _buildName() {
    return Tooltip(
        message: widget.drf,
        child: Text(overflow: TextOverflow.ellipsis, widget.drf));
  }

  Widget _buildDescription() {
    if (deviceInfo == null) {
      return Container();
    } else {
      return Text(
          key: Key("parameter_description_${widget.drf}"),
          overflow: TextOverflow.ellipsis,
          deviceInfo?.description ?? "",
          style: widget.wide
              ? Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontStyle: FontStyle.italic)
              : Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontStyle: FontStyle.italic, color: Colors.grey));
    }
  }

  Widget _buildProperties({required bool wide}) {
    return wide ? _layoutPropertiesWide() : _layoutPropertiesNarrow();
  }

  Widget _layoutPropertiesWide() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Visibility(
            visible: hasSettingProperty,
            child: SettingControlWidget(
                key: Key("parameter_setting_${widget.drf}"),
                drf: widget.drf,
                displayUnits: widget.displayUnits,
                units: settingUnits,
                wide: true)),
        const SizedBox(width: 8.0),
        SizedBox(
            width: 128.0,
            child: Visibility(
                visible: hasReadingProperty,
                child: StreamBuilder(
                    stream: widget.dpm.monitorDevices([widget.drf]),
                    builder: _readingBuilder))),
        const SizedBox(width: 8.0),
        SizedBox(
            width: 128.0,
            child: StreamBuilder(
                stream: widget.dpm.monitorDigitalStatusDevices([widget.drf]),
                builder: _basicStatusBuilder))
      ]),
      Visibility(
          visible: widget.displayAlarmDetails,
          child: (deviceInfo != null && deviceInfo!.alarm != null)
              ? ParameterAlarmDetailsWidget(
                  drf: widget.drf, alarmBlock: deviceInfo!.alarm!)
              : Container()),
    ]);
  }

  Widget _layoutPropertiesNarrow() {
    return Row(children: [
      Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        SettingControlWidget(
            key: Key("parameter_setting_${widget.drf}"),
            drf: widget.drf,
            displayUnits: widget.displayUnits,
            units: settingUnits,
            wide: false),
        const SizedBox(width: 8.0),
        StreamBuilder(
            stream: widget.dpm.monitorDevices([widget.drf]),
            builder: _readingBuilder),
        const SizedBox(width: 8.0),
        Visibility(
            visible: widget.displayAlarmDetails,
            child: (deviceInfo != null && deviceInfo!.alarm != null)
                ? ParameterAlarmDetailsWidget(
                    drf: widget.drf, alarmBlock: deviceInfo!.alarm!)
                : Container()),
        StreamBuilder(
            stream: widget.dpm.monitorDigitalStatusDevices([widget.drf]),
            builder: _basicStatusBuilder)
      ]))
    ]);
  }

  Widget _buildExpandOrCollapseExtendedStatusButton() {
    if (_hasExtendedStatusProperty()) {
      return _displayExtendedStatus
          ? _buildExpandExtendedStatusButton()
          : _buildCollapseExtendedStatusButton();
    } else {
      return Container();
    }
  }

  bool _hasExtendedStatusProperty() {
    return !(deviceInfo == null || deviceInfo!.basicStatus == null);
  }

  Widget _buildExpandExtendedStatusButton() {
    return IconButton(
        key: Key("parameter_collapsedigitalstatus_${widget.drf}"),
        icon: const Icon(Icons.expand_less),
        onPressed: _toggleDigitalStatus);
  }

  Widget _buildCollapseExtendedStatusButton() {
    return IconButton(
        key: Key("parameter_expanddigitalstatus_${widget.drf}"),
        icon: const Icon(Icons.expand_more),
        onPressed: _toggleDigitalStatus);
  }

  Widget _buildExtendedStatusRow() {
    return LayoutBuilder(builder: (context, constraints) {
      return constraints.maxWidth > 800
          ? _buildExtendedStatusRowWide()
          : _buildExtendedStatusRowNarrow();
    });
  }

  Widget _buildExtendedStatusRowWide() {
    return Row(children: [
      const Spacer(),
      SizedBox(
          width: 400,
          child: StreamBuilder(
              stream: widget.dpm.monitorDigitalStatusDevices([widget.drf]),
              builder: _extendedStatusBuilder)),
      const Spacer(),
      deviceInfo != null
          ? SizedBox(
              width: 400,
              child: CommandButtonMenuWidget(
                  drf: widget.drf, deviceInfo: deviceInfo!))
          : Container(),
      const Spacer()
    ]);
  }

  Widget _buildExtendedStatusRowNarrow() {
    return Column(children: [
      StreamBuilder(
          stream: widget.dpm.monitorDigitalStatusDevices([widget.drf]),
          builder: _extendedStatusBuilder),
      deviceInfo != null
          ? CommandButtonMenuWidget(drf: widget.drf, deviceInfo: deviceInfo!)
          : Container()
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
          drf: widget.drf, digitalStatus: snapshot.data!, wide: widget.wide);
    } else {
      return SizedBox(width: widget.wide ? 128.0 : 32.0);
    }
  }

  Widget _extendedStatusBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      return ParameterExtendedStatusWidget(
          drf: widget.drf, digitalStatus: snapshot.data!);
    } else {
      return Container();
    }
  }

  Widget _buildParam(String? value, String? units, {required Key key}) {
    return value == null
        ? Container()
        : (units == null
            ? Text(key: key, textAlign: TextAlign.end, value)
            : Row(key: key, children: [
                Expanded(child: Text(textAlign: TextAlign.end, value)),
                const SizedBox(width: 6.0),
                Text(units, style: const TextStyle(color: Colors.grey))
              ]));
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
}
