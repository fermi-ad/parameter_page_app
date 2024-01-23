import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/widgets/command_menu_widget.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';
import 'package:parameter_page/widgets/parameter_alarm_status_widget.dart';
import 'package:parameter_page/widgets/parameter_basic_status_widget.dart';
import 'package:parameter_page/widgets/parameter_beam_inhibit_status_widget.dart';
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
  final bool settingsAllowed;

  const ParameterWidget(
      {required this.drf,
      required this.editMode,
      required this.wide,
      required this.settingsAllowed,
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
                displayExtendedStatus: displayExtendedStatus,
                settingsAllowed: settingsAllowed,
              ));
  }
}

class _ActiveParamWidget extends StatefulWidget {
  final String drf;
  final DataAcquisitionWidget dpm;
  final bool wide;
  final DisplayUnits displayUnits;
  final bool displayAlarmDetails;
  final bool displayExtendedStatus;
  final bool settingsAllowed;

  const _ActiveParamWidget(
      {required this.drf,
      required this.dpm,
      required this.wide,
      required this.displayUnits,
      required this.displayAlarmDetails,
      required this.displayExtendedStatus,
      required this.settingsAllowed});

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

  bool get hasBasicStatusProperty {
    return deviceInfo?.basicStatus != null;
  }

  bool get hasDigitalAlarmProperty {
    return deviceInfo?.digitalAlarm != null;
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
        _deviceInfoFailure = false;
        return value;
      }, onError: (Object error) {
        deviceInfo = const DeviceInfo(di: 0, description: '', name: '');
        _deviceInfoFailure = true;
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
    if (_deviceInfoFailure) {
      return _buildDeviceInfoFailureError(context);
    } else if (deviceInfo == null) {
      return Row(children: [
        const CircularProgressIndicator(),
        Expanded(child: Container())
      ]);
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
                  .copyWith(fontStyle: FontStyle.italic));
    }
  }

  Widget _buildDeviceInfoFailureError(BuildContext context) {
    return Row(key: Key("parameter_infoerror_${widget.drf}"), children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
          child: Icon(Icons.error, color: Theme.of(context).colorScheme.error)),
      Text("Failed to get this parameter",
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.error))
    ]);
  }

  Widget _buildProperties({required bool wide}) {
    return wide ? _layoutPropertiesWide() : _layoutPropertiesNarrow();
  }

  Widget _layoutPropertiesWide() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        SizedBox(
            width: 300,
            child: Visibility(
                visible: hasSettingProperty,
                child: SettingControlWidget(
                    key: Key("parameter_setting_${widget.drf}"),
                    settingsAllowed: widget.settingsAllowed,
                    drf: widget.drf,
                    displayUnits: widget.displayUnits,
                    units: settingUnits,
                    wide: true))),
        const SizedBox(width: 8.0),
        SizedBox(
            width: 128.0,
            child: Visibility(
                visible: hasReadingProperty,
                child: StreamBuilder(
                    stream: widget.dpm.monitorDevices([widget.drf]),
                    builder: _readingBuilder))),
        StreamBuilder(
            stream: widget.dpm.monitorAnalogAlarmDevices([widget.drf]),
            builder: _analogAlarmBuilder),
        const SizedBox(width: 8.0),
        SizedBox(
            width: 128.0,
            child: Visibility(
                visible: hasBasicStatusProperty,
                child: StreamBuilder(
                    stream:
                        widget.dpm.monitorDigitalStatusDevices([widget.drf]),
                    builder: _basicStatusBuilder))),
        StreamBuilder(
            stream: widget.dpm.monitorDigitalAlarmDevices([widget.drf]),
            builder: _digitalAlarmBuilder),
        StreamBuilder(
            stream: widget.dpm.monitorDigitalAlarmBeamAbortInhibit(widget.drf),
            builder: _digitalAlarmBeamInhibitBuilder),
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
        Visibility(
            visible: hasSettingProperty,
            child: SettingControlWidget(
                key: Key("parameter_setting_${widget.drf}"),
                settingsAllowed: widget.settingsAllowed,
                drf: widget.drf,
                displayUnits: widget.displayUnits,
                units: settingUnits,
                wide: false)),
        const SizedBox(width: 8.0),
        Visibility(
            visible: hasReadingProperty,
            child: StreamBuilder(
                stream: widget.dpm.monitorDevices([widget.drf]),
                builder: _readingBuilder)),
        const SizedBox(width: 8.0),
        Visibility(
            visible: widget.displayAlarmDetails,
            child: (deviceInfo != null && deviceInfo!.alarm != null)
                ? ParameterAlarmDetailsWidget(
                    drf: widget.drf, alarmBlock: deviceInfo!.alarm!)
                : Container()),
        Visibility(
            visible: hasBasicStatusProperty,
            child: StreamBuilder(
                stream: widget.dpm.monitorDigitalStatusDevices([widget.drf]),
                builder: _basicStatusBuilder))
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
                  drf: widget.drf,
                  deviceInfo: deviceInfo!,
                  settingsAllowed: widget.settingsAllowed))
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
          ? CommandButtonMenuWidget(
              drf: widget.drf,
              deviceInfo: deviceInfo!,
              settingsAllowed: widget.settingsAllowed)
          : Container()
    ]);
  }

  void _toggleDigitalStatus() {
    setState(() => _displayExtendedStatus = !_displayExtendedStatus);
  }

  Widget _readingBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      return _buildParam(
          context, _extractValueString(from: snapshot), readingUnits,
          key: Key("parameter_reading_${widget.drf}"),
          isAlarming: _lastAlarmStatus != null &&
              _lastAlarmStatus!.state == AlarmState.alarming);
    } else {
      return _buildParam(context, null, readingUnits,
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

  Widget _analogAlarmBuilder(context, snapshot) {
    if (_deviceHasAnalogAlarmBlock &&
        snapshot.connectionState == ConnectionState.active) {
      final newAlarmStatus = snapshot!.data as AlarmStatus;

      if (_lastAlarmStatus == null ||
          newAlarmStatus.state != _lastAlarmStatus!.state) {
        SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
              _lastAlarmStatus = newAlarmStatus;
            }));
      }

      return Container(
          key: Key("parameter_analogalarm_${widget.drf}"),
          child: ParameterAlarmStatusWidget(
              isDigital: false,
              settingsAllowed: widget.settingsAllowed,
              alarmState: newAlarmStatus.state,
              drf: widget.drf));
    } else {
      return const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 0), child: SizedBox(width: 40));
    }
  }

  Widget _digitalAlarmBuilder(BuildContext context, AsyncSnapshot snapshot) {
    if (_deviceHasDigitalAlarmBlock &&
        snapshot.connectionState == ConnectionState.active) {
      final newAlarmStatus = snapshot.data as AlarmStatus;

      return Container(
          key: Key("parameter_digitalalarm_${widget.drf}"),
          child: ParameterAlarmStatusWidget(
              isDigital: true,
              settingsAllowed: widget.settingsAllowed,
              alarmState: newAlarmStatus.state,
              drf: widget.drf));
    } else {
      return const Padding(
          padding: EdgeInsets.fromLTRB(8, 0, 0, 0), child: SizedBox(width: 40));
    }
  }

  Widget _digitalAlarmBeamInhibitBuilder(
      BuildContext context, AsyncSnapshot snapshot) {
    if (_deviceHasDigitalAlarmBlock &&
        snapshot.connectionState == ConnectionState.active) {
      final isByPassed = snapshot.data as bool;

      return ParameterBeamInhibitStatusWidget(
          state: _beamInhibitState(
              abort: deviceInfo!.digitalAlarm!.abort, byPassed: isByPassed),
          drf: widget.drf);
    } else {
      return const SizedBox(width: 16);
    }
  }

  BeamInhibitState _beamInhibitState(
      {required bool abort, required bool byPassed}) {
    return abort
        ? (byPassed ? BeamInhibitState.byPassed : BeamInhibitState.willInhibit)
        : BeamInhibitState.wontInhibit;
  }

  Widget _buildParam(BuildContext context, String? value, String? units,
      {required Key key, bool isAlarming = false}) {
    return value == null
        ? Container()
        : (units == null
            ? Text(value,
                key: key,
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: isAlarming
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary))
            : Row(key: key, children: [
                Expanded(
                    child: Text(value,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: isAlarming
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary))),
                const SizedBox(width: 6.0),
                Text(units,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.outline))
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

  bool get _deviceHasAnalogAlarmBlock {
    return deviceInfo != null && deviceInfo!.alarm != null;
  }

  bool get _deviceHasDigitalAlarmBlock {
    return deviceInfo != null && deviceInfo!.digitalAlarm != null;
  }

  bool _deviceInfoFailure = false;

  AlarmStatus? _lastAlarmStatus;
}
