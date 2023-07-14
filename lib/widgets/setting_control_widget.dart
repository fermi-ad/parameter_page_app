import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingControlWidget extends StatefulWidget {
  final String drf;

  final String value;

  final bool wide;

  final Function(String)? onSubmitted;

  const SettingControlWidget(
      {super.key,
      required this.drf,
      this.onSubmitted,
      this.value = "0.0",
      this.wide = true});

  @override
  State<StatefulWidget> createState() {
    return _SettingControlState();
  }
}

class _SettingControlState extends State<SettingControlWidget> {
  @override
  Widget build(BuildContext context) {
    return _entryMode ? _buildInput() : _buildDisplay();
  }

  Widget _buildDisplay() {
    return Container(
        key: Key("parameter_settingdisplay_${widget.drf}"),
        child: GestureDetector(
            onTap: _handleDisplayTap,
            child:
                Text(key: widget.key, textAlign: TextAlign.end, widget.value)));
  }

  void _handleDisplayTap() {
    setState(() {
      _entryMode = true;
      _textFieldController.text = widget.value;
    });
  }

  Widget _buildInput() {
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
  }

  void _handleAbort() {
    setState(() {
      _entryMode = false;
    });
  }

  bool _entryMode = false;

  final _textFieldController = TextEditingController();
}
