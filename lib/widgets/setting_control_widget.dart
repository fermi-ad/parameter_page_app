import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';

class SettingControlWidget extends StatefulWidget {
  final String drf;

  final String? units;

  final DisplayUnits displayUnits;

  final bool wide;

  final Function(String)? onSubmitted;

  const SettingControlWidget(
      {super.key,
      required this.drf,
      this.onSubmitted,
      this.units,
      required this.displayUnits,
      this.wide = true});

  @override
  State<StatefulWidget> createState() {
    return _SettingControlState();
  }
}

enum _SettingControlInternalState {
  displaying,
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
    return Row(children: [
      _buildUndo(context),
      const SizedBox(width: 6.0),
      SizedBox(width: 128.0, child: _buildStates(context)),
      const SizedBox(width: 6.0),
      _buildUnits(),
      const SizedBox(width: 6.0),
      _buildSubmitButton(context),
      const SizedBox(width: 6.0),
      _buildCancelButton()
    ]);
  }

  Widget _buildUndo(BuildContext context) {
    return StreamBuilder(
        builder: _undoDisplayBuilder,
        stream: DataAcquisitionWidget.of(context)
            .monitorSettingProperty([widget.drf]));
  }

  Widget _buildStates(BuildContext context) {
    switch (_state) {
      case _SettingControlInternalState.displaying:
        return _buildDisplayingState();

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
        : Text(widget.units!, style: const TextStyle(color: Colors.grey));
  }

  Widget _buildSubmitButton(BuildContext context) {
    return _state == _SettingControlInternalState.editing
        ? GestureDetector(
            onTap: () => _handleSubmitted(context),
            child: const Icon(Icons.check_circle, color: Colors.blue))
        : const SizedBox(width: 32.0);
  }

  Widget _buildCancelButton() {
    return _state == _SettingControlInternalState.editing
        ? GestureDetector(
            onTap: _handleAbort,
            child: const Icon(Icons.cancel, color: Colors.red))
        : const SizedBox(width: 32.0);
  }

  Widget _buildDisplayingState() {
    return GestureDetector(
        onTap: _handleDisplayTap,
        child: StreamBuilder(
            builder: _settingDisplayBuilder,
            stream: DataAcquisitionWidget.of(context)
                .monitorSettingProperty([widget.drf])));
  }

  Widget _buildDisplayingErrorState() {
    _startErrorDisplayTimer();

    return Container(
        key: Key("parameter_settingerror_${widget.drf}"),
        child: Text(textAlign: TextAlign.end, "$_facilityCode $_errorCode"));
  }

  Widget _buildEditingState(BuildContext context) {
    _startEditingTimeoutTimer();

    return Container(
        key: Key("parameter_settinginput_${widget.drf}"),
        child: RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (key) {
            if (key.isKeyPressed(LogicalKeyboardKey.escape)) {
              _handleAbort();
            }
          },
          child: TextFormField(
              key: Key("parameter_settingtextfield_${widget.drf}"),
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
                style: const TextStyle(color: Colors.purple),
                _initialSettingValue!)));
  }

  Widget _settingDisplayBuilder(context, snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      _lastSettingValue = _extractValueString(from: snapshot);
      return Container(
          key: Key("parameter_settingdisplay_${widget.drf}"),
          child: Text(textAlign: TextAlign.end, _lastSettingValue!));
    } else {
      return Container(
          key: Key("parameter_settingloading_${widget.drf}"),
          child: const Text(textAlign: TextAlign.end, "Loading..."));
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

  void _handleUndoTap() {
    _submitSetting(_initialSettingValue!);
  }

  void _handleDisplayTap() {
    setState(() {
      _state = _SettingControlInternalState.editing;
      _textFieldController.text = _lastSettingValue!;
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

  _SettingControlInternalState _state = _SettingControlInternalState.displaying;

  String? _pendingSettingValue;

  final _textFieldController = TextEditingController();

  int? _facilityCode;

  int? _errorCode;

  Timer? _errorDisplayTimeoutTimer;

  Timer? _editingTimeoutTimer;

  String? _initialSettingValue;

  String? _lastSettingValue;
}
