import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

enum _SettingControlInternalState { display, editing, setting_pending }

class _SettingControlState extends State<SettingControlWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(height: 34.0, width: 100.0, child: _buildStates()),
      const SizedBox(width: 6.0),
      widget.units == null
          ? Container()
          : Text(widget.units!, style: const TextStyle(color: Colors.grey))
    ]);
  }

  Widget _buildStates() {
    switch (_state) {
      case _SettingControlInternalState.display:
        return _buildDisplayState();

      case _SettingControlInternalState.editing:
        return _buildEditingState();

      case _SettingControlInternalState.setting_pending:
        return _buildSettingPendingState();
    }
  }

  Widget _buildDisplayState() {
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

  Widget _buildEditingState() {
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
              onEditingComplete: () => _handleSubmitted(),
              decoration:
                  const InputDecoration(border: UnderlineInputBorder())),
        ));
  }

  void _handleSubmitted() {
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(_textFieldController.text);
    }

    setState(() {
      _state = _SettingControlInternalState.display;
    });
  }

  void _handleAbort() {
    setState(() {
      _state = _SettingControlInternalState.display;
    });
  }

  Widget _buildSettingPendingState() {
    return Container();
  }

  _SettingControlInternalState _state = _SettingControlInternalState.display;

  final _textFieldController = TextEditingController();
}
