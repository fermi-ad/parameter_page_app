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
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(alignment: Alignment.center, children: [
          if (_displayState == _CommandButtonDisplayState.pending)
            const Icon(Icons.pending),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _displayState == _CommandButtonDisplayState.error
                          ? Colors.red
                          : Colors.blue,
                  elevation: 0.0,
                  minimumSize: const Size.fromHeight(40)),
              onPressed: _displayState == _CommandButtonDisplayState.pending
                  ? null
                  : _handlePress,
              child: Text(
                  style: const TextStyle(color: Colors.white),
                  _displayState == _CommandButtonDisplayState.error
                      ? _errorMessage!
                      : widget.longName))
        ]));
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
    setState(() {
      _displayState = _CommandButtonDisplayState.error;
      _errorMessage = "$facilityCode $errorCode";
    });
  }

  _CommandButtonDisplayState _displayState = _CommandButtonDisplayState.ready;

  String? _errorMessage;
}
