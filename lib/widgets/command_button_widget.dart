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

class _CommandButtonState extends State<CommandButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(alignment: Alignment.center, children: [
          if (_isPending) const Icon(Icons.pending),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0.0,
                  minimumSize: const Size.fromHeight(40)),
              onPressed: _isPending ? null : _handlePress,
              child: Text(
                  style: const TextStyle(color: Colors.white), widget.longName))
        ]));
  }

  void _handlePress() {
    _sendCommand();

    setState(() {
      _isPending = true;
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
      _isPending = false;
    });
  }

  void _sendCommandFailure(int facilityCode, int errorCode) {}

  bool _isPending = false;
}
