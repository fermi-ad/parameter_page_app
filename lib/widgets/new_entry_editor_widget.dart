import 'package:flutter/material.dart';

import 'data_acquisition_widget.dart';
import '../entities/page_entry.dart';

class NewEntryEditorWidget extends StatefulWidget {
  final Function(PageEntry) onSubmitted;

  const NewEntryEditorWidget({super.key, required this.onSubmitted});

  @override
  State<NewEntryEditorWidget> createState() {
    return _NewEntryEditorState();
  }
}

class _NewEntryEditorState extends State<NewEntryEditorWidget> {
  TextEditingController controller = TextEditingController();

  late DataAcquisitionWidget _daqWidget;

  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    _daqWidget = DataAcquisitionWidget.of(context);
    return TextField(
        focusNode: _focusNode,
        key: const Key("new_entry_textfield"),
        autofocus: true,
        maxLines: 1,
        minLines: 1,
        controller: controller,
        onSubmitted: (value) {
          setState(() {
            controller.text = "";
            _focusNode.requestFocus();
          });

          widget.onSubmitted(_generatePageEntryFrom(textInput: value));
        });
  }

  PageEntry _generatePageEntryFrom({required final String textInput}) {
    if (_daqWidget.isACNETDRF(textInput) ||
        _daqWidget.isProcessVariable(textInput)) {
      return ParameterEntry(textInput,
          label: "", key: Key("parameter_row_$textInput"));
    } else if (_isHardComment(textInput)) {
      return CommentEntry(_stripBang(textInput));
    } else {
      return CommentEntry(textInput);
    }
  }

  bool _isHardComment(String val) {
    return "!" == val[0];
  }

  String _stripBang(String textInput) {
    return textInput.substring(1);
  }
}