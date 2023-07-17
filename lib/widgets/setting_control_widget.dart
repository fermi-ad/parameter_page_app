import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parameter_page/widgets/data_acquisition_widget.dart';

class SettingControlWidget extends StatefulWidget {
  final String drf;

  final String value;

  final String? units;

  final bool wide;

  final Function(String)? onSubmitted;

  const SettingControlWidget(
      {super.key,
      required this.drf,
      this.onSubmitted,
      this.value = "0.0",
      this.units,
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
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(height: 34.0, width: 100.0, child: _buildStates(context)),
      const SizedBox(width: 6.0),
      widget.units == null
          ? Container()
          : Text(widget.units!, style: const TextStyle(color: Colors.grey))
    ]);
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

  Widget _buildDisplayingState() {
    return Container(
        key: Key("parameter_settingdisplay_${widget.drf}"),
        child: GestureDetector(
            onTap: _handleDisplayTap,
            child: Text(textAlign: TextAlign.end, widget.value)));
  }

  void _handleDisplayTap() {
    setState(() {
      _state = _SettingControlInternalState.editing;
      _textFieldController.text = widget.value;
    });
  }

  Widget _buildDisplayingErrorState() {
    return Container();
  }

  Widget _buildEditingState(BuildContext context) {
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
              controller: _textFieldController,
              onTapOutside: (event) => _handleAbort(),
              onEditingComplete: () => _handleSubmitted(context),
              decoration:
                  const InputDecoration(border: UnderlineInputBorder())),
        ));
  }

  void _handleSubmitted(BuildContext context) {
    final newValue = _textFieldController.text;

    final DataAcquisitionWidget daqWidget = DataAcquisitionWidget.of(context);
    daqWidget.submit(forDRF: widget.drf, newSetting: newValue).listen((status) {
      if (status.facilityCode == 1 && status.errorCode == 0) {
        setState(() {
          _state = _SettingControlInternalState.displaying;
        });
      }
    });

    if (widget.onSubmitted != null) {
      widget.onSubmitted!(newValue);
    }
    _pendingSettingValue = newValue;

    setState(() {
      _state = _SettingControlInternalState.settingPending;
    });
  }

  void _handleAbort() {
    setState(() {
      _state = _SettingControlInternalState.displaying;
    });
  }

  Widget _buildSettingPendingState() {
    return Row(key: Key("parameter_settingdisplay_${widget.drf}"), children: [
      const Icon(Icons.pending),
      const SizedBox(width: 8.0),
      Text(textAlign: TextAlign.end, _pendingSettingValue!)
    ]);
  }

  _SettingControlInternalState _state = _SettingControlInternalState.displaying;

  String? _pendingSettingValue;

  final _textFieldController = TextEditingController();
}