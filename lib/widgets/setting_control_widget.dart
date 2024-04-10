import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';

class SettingControlWidget extends StatefulWidget {
  final String drf;

  final String? units;

  final DisplayUnits displayUnits;

  final bool wide;

  final Function(String)? onSubmitted;

  final bool settingsAllowed;

  final bool knobbingEnabled;

  final double knobbingStepSize;

  final Stream<double>? knobbingStream;

  const SettingControlWidget(
      {super.key,
      required this.drf,
      this.onSubmitted,
      this.units,
      required this.displayUnits,
      this.wide = true,
      this.settingsAllowed = true,
      this.knobbingEnabled = false,
      this.knobbingStepSize = 1.0,
      this.knobbingStream});

  @override
  State<StatefulWidget> createState() {
    return _SettingControlState();
  }
}

enum _SettingControlInternalState {
  displaying,
  displayingOptimistic,
  displayingError,
  editing,
  settingPending
}

class _SettingControlState extends State<SettingControlWidget> {
  @override
  void dispose() {
    _errorDisplayTimeoutTimer?.cancel();
    _editingTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _knobbingStreamSubscription?.cancel();
    _knobbingStreamSubscription =
        widget.knobbingStream?.listen(_handleKnobStream);
    return widget.wide ? _buildWide(context) : _buildNarrow(context);
  }

  Widget _buildWide(BuildContext context) {
    return SizedBox(
        height: 64,
        child: Column(children: [
          Flexible(
              child: Row(children: [
            _buildUndo(context),
            const SizedBox(width: 4.0),
            SizedBox(width: 128.0, child: _buildStates(context)),
            SizedBox(width: 56.0, child: _buildUnits()),
            SizedBox(width: 32.0, child: _buildSubmitButton(context)),
            SizedBox(width: 32.0, child: _buildCancelButton())
          ])),
          Flexible(child: _buildKnobbingControls())
        ]));
  }

  Widget _buildNarrow(BuildContext context) {
    return Row(children: [
      _buildUndo(context),
      Expanded(child: _buildStates(context)),
      _buildUnits(),
      _buildSubmitButton(context),
      _buildCancelButton()
    ]);
  }

  Widget _buildUndo(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48.0),
        child: StreamBuilder(
            builder: _undoDisplayBuilder,
            stream: DataAcquisitionWidget.of(context)
                .monitorSettingProperty([widget.drf])));
  }

  Widget _buildStates(BuildContext context) {
    switch (_state) {
      case _SettingControlInternalState.displaying:
        return _buildDisplayingState();

      case _SettingControlInternalState.displayingOptimistic:
        return _buildDisplayingOptimisticState();

      case _SettingControlInternalState.displayingError:
        return _buildDisplayingErrorState();

      case _SettingControlInternalState.editing:
        return _buildEditingState(context);

      case _SettingControlInternalState.settingPending:
        return _buildSettingPendingState();
    }
  }

  Widget _buildUnits() {
    return widget.units == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
            child: Text(widget.units!,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.outline)));
  }

  Widget _buildSubmitButton(BuildContext context) {
    return _state == _SettingControlInternalState.editing
        ? GestureDetector(
            onTap: () => _handleSubmitted(context),
            child: Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                child: Icon(Icons.check_circle,
                    color: Theme.of(context).colorScheme.primary)))
        : Container();
  }

  Widget _buildCancelButton() {
    return _state == _SettingControlInternalState.editing
        ? GestureDetector(
            onTap: _handleAbort,
            child: Padding(
                padding: const EdgeInsets.fromLTRB(4.0, 0.0, 0.0, 0.0),
                child: Icon(Icons.cancel,
                    color: Theme.of(context).colorScheme.error)))
        : Container();
  }

  Widget _buildKnobbingControls() {
    final f = NumberFormat("######0.0#####", "en_US");
    final stepSize = f.format(widget.knobbingStepSize);

    return Visibility(
        visible: _showKnobbingControls,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
                key: Key("parameter_settingknobbing_${widget.drf}"),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Knob +/- (F5/F4): ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline)),
                  Text(stepSize,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline))
                ])));
  }

  Widget _buildDisplayingState() {
    return GestureDetector(
        onTap: _handleDisplayTap,
        child: StreamBuilder(
            builder: _settingDisplayBuilder,
            stream: DataAcquisitionWidget.of(context)
                .monitorSettingProperty([widget.drf])));
  }

  Widget _buildDisplayingOptimisticState() {
    return GestureDetector(
        onTap: _handleDisplayTap,
        child: Container(
            key: Key("parameter_settingdisplay_${widget.drf}"),
            child: Text(
                textAlign: TextAlign.end,
                _lastSetting!.$2,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.primary))));
  }

  Widget _buildDisplayingErrorState() {
    _startErrorDisplayTimer();

    return Container(
        key: Key("parameter_settingerror_${widget.drf}"),
        child: Text(
            textAlign: TextAlign.start,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
            "$_facilityCode $_errorCode"));
  }

  Widget _buildEditingState(BuildContext context) {
    _startEditingTimeoutTimer();

    return Container(
        key: Key("parameter_settinginput_${widget.drf}"),
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: _handleEditingKey,
          child: TextFormField(
              key: Key("parameter_settingtextfield_${widget.drf}"),
              autofocus: true,
              textAlign: TextAlign.end,
              controller: _textFieldController,
              onChanged: (event) => _startEditingTimeoutTimer(),
              onEditingComplete: () => _handleSubmitted(context),
              decoration:
                  const InputDecoration(border: UnderlineInputBorder())),
        ));
  }

  Widget _buildSettingPendingState() {
    return Row(
        key: Key("parameter_settingpendingdisplay_${widget.drf}"),
        children: [
          const Spacer(),
          const Icon(Icons.pending),
          const SizedBox(width: 8.0),
          Text(textAlign: TextAlign.end, _pendingSettingValue!)
        ]);
  }

  Widget _undoDisplayBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      var newSettingValue = _extractValueString(from: snapshot);

      _initialSettingValue ??= newSettingValue;

      return newSettingValue != _initialSettingValue
          ? _buildUndoDisplay()
          : Container();
    } else {
      return Container();
    }
  }

  Widget _buildUndoDisplay() {
    return Container(
        key: Key("parameter_settingundo_${widget.drf}"),
        child: GestureDetector(
            onTap: _handleUndoTap,
            child: Text(
                textAlign: TextAlign.end,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
                _initialSettingValue!)));
  }

  Widget _settingDisplayBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      _lastSetting =
          (snapshot.data!.value, _extractValueString(from: snapshot));

      return Container(
          key: Key("parameter_settingdisplay_${widget.drf}"),
          child: Text(
              textAlign: TextAlign.end,
              _lastSetting!.$2,
              style: TextStyle(color: Theme.of(context).colorScheme.primary)));
    } else {
      return Container(
          key: Key("parameter_settingloading_${widget.drf}"),
          child: Text(
              textAlign: TextAlign.end,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
              "Loading..."));
    }
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

  void _startErrorDisplayTimer() {
    _errorDisplayTimeoutTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _state = _SettingControlInternalState.displaying;
      });
    });
  }

  void _startEditingTimeoutTimer() {
    _editingTimeoutTimer?.cancel();
    _editingTimeoutTimer = Timer(const Duration(seconds: 6), () {
      setState(() {
        _state = _SettingControlInternalState.displaying;
      });
    });
  }

  void _handleEditingKey(KeyEvent event) {
    if (event is KeyUpEvent) {
      return;
    }

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _handleAbort();
    } else if (event.logicalKey == LogicalKeyboardKey.f5) {
      _handleKnob(withStep: widget.knobbingStepSize);
    } else if (event.logicalKey == LogicalKeyboardKey.f4) {
      _handleKnob(withStep: -widget.knobbingStepSize);
    }
  }

  void _handleUndoTap() {
    if (!widget.settingsAllowed) {
      return;
    }

    _submitSetting(_initialSettingValue!);
  }

  void _handleDisplayTap() {
    if (!widget.settingsAllowed) {
      return;
    }
    setState(() {
      _state = _SettingControlInternalState.editing;
      _textFieldController.text = _lastSetting!.$2;
    });
  }

  void _handleKnobStream(double knobV) {
    final newValue = _lastSetting!.$1 + knobV * widget.knobbingStepSize;

    _submitKnobbedSetting(newValue.toString());

    setState(() {
      _lastSetting = (newValue, newValue.toStringAsPrecision(4));
      _state = _SettingControlInternalState.displayingOptimistic;
    });
  }

  void _handleKnob({required double withStep}) {
    final newValue = _lastSetting!.$1 + withStep;

    _submitKnobbedSetting(newValue.toString());

    setState(() {
      _lastSetting = (newValue, newValue.toStringAsPrecision(4));
      _textFieldController.text = _lastSetting!.$2;
    });
  }

  void _handleSubmitted(BuildContext context) {
    _submitSetting(_textFieldController.text);
  }

  void _handleAbort() {
    setState(() {
      _state = _SettingControlInternalState.displaying;
    });
  }

  void _submitKnobbedSetting(String newValue) {
    final DataAcquisitionWidget daqWidget = DataAcquisitionWidget.of(context);
    daqWidget.submit(forDRF: widget.drf, newSetting: newValue);
  }

  void _submitSetting(String newValue) {
    final DataAcquisitionWidget daqWidget = DataAcquisitionWidget.of(context);
    daqWidget.submit(
        forDRF: widget.drf,
        newSetting: newValue,
        onSuccess: _settingSuccess,
        onFailure: _settingFailure);

    widget.onSubmitted?.call(newValue);

    setState(() {
      _editingTimeoutTimer?.cancel();
      _pendingSettingValue = newValue;
      _state = _SettingControlInternalState.settingPending;
    });
  }

  void _settingSuccess() {
    setState(() {
      _state = _SettingControlInternalState.displaying;
    });
  }

  void _settingFailure(int facilityCode, int errorCode) {
    setState(() {
      _facilityCode = facilityCode;
      _errorCode = errorCode;
      _state = _SettingControlInternalState.displayingError;
    });
  }

  bool get _showKnobbingControls {
    return widget.knobbingEnabled &&
        _state == _SettingControlInternalState.editing;
  }

  _SettingControlInternalState _state = _SettingControlInternalState.displaying;

  String? _pendingSettingValue;

  final _textFieldController = TextEditingController();

  int? _facilityCode;

  int? _errorCode;

  Timer? _errorDisplayTimeoutTimer;

  Timer? _editingTimeoutTimer;

  String? _initialSettingValue;

  (double, String)? _lastSetting;

  StreamSubscription<double>? _knobbingStreamSubscription;
}
