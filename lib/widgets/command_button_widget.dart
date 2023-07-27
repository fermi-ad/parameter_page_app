import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

class CommandButtonWidget extends StatefulWidget {
  final String drf;

  final int value;

  final String longName;

  const CommandButtonWidget(
      {super.key,
      required this.drf,
      required this.value,
      required this.longName});

  @override
  State<StatefulWidget> createState() {
    return _CommandButtonState();
  }
}

enum _CommandButtonDisplayState { ready, pending, error }

class _CommandButtonState extends State<CommandButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(4.0), child: _buildButton());
  }

  Widget _buildButton() {
    switch (_displayState) {
      case _CommandButtonDisplayState.ready:
        return _buildReadyButton();
      case _CommandButtonDisplayState.pending:
        return _buildPendingButton();
      case _CommandButtonDisplayState.error:
        return _buildErrorButton();
    }
  }

  Widget _buildReadyButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            elevation: 0.0,
            minimumSize: const Size.fromHeight(40)),
        onPressed: _handlePress,
        child: Text(widget.longName));
  }

  Widget _buildPendingButton() {
    return Stack(alignment: Alignment.center, children: [
      const Icon(Icons.pending),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 0.0,
              minimumSize: const Size.fromHeight(40)),
          onPressed: null,
          child: Text(
              style: const TextStyle(color: Colors.white), widget.longName))
    ]);
  }

  Widget _buildErrorButton() {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            elevation: 0.0,
            minimumSize: const Size.fromHeight(40)),
        onPressed: _handlePress,
        child:
            Text(style: const TextStyle(color: Colors.white), _errorMessage!));
  }

  void _handlePress() {
    _sendCommand();

    setState(() {
      _displayState = _CommandButtonDisplayState.pending;
    });

    // widget.onSubmitted?.call(newValue);
  }

  void _sendCommand() {
    final DataAcquisitionWidget daqWidget = DataAcquisitionWidget.of(context);
    daqWidget.sendCommand(
        toDRF: widget.drf,
        value: widget.value,
        onSuccess: _sendCommandSuccess,
        onFailure: _sendCommandFailure);
  }

  void _sendCommandSuccess() {
    setState(() {
      _displayState = _CommandButtonDisplayState.ready;
    });
  }

  void _sendCommandFailure(int facilityCode, int errorCode) {
    _startErrorDisplayTimeoutTimer();

    setState(() {
      _displayState = _CommandButtonDisplayState.error;
      _errorMessage = "$facilityCode $errorCode";
    });
  }

  void _startErrorDisplayTimeoutTimer() {
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _displayState = _CommandButtonDisplayState.ready;
      });
    });
  }

  _CommandButtonDisplayState _displayState = _CommandButtonDisplayState.ready;

  String? _errorMessage;
}
