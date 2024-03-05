import 'package:flutter/material.dart';

import 'data_acquisition_widget.dart';
import '../entities/page_entry.dart';

class NewEntryEditorWidget extends StatefulWidget {
  final Function(List<PageEntry>) onSubmitted;

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

          widget.onSubmitted(_extractPageEntriesFrom(textInput: value));
        });
  }

  List<PageEntry> _extractPageEntriesFrom({required final String textInput}) {
    if (_isHardComment(textInput)) {
      return [CommentEntry(_stripBang(textInput))];
    } else if (_isMult(textInput)) {
      return [MultEntry(textInput)];
    } else {
      final entries = _findAllTheParameterEntries(inside: textInput);
      if (entries.isEmpty && textInput.length > 1) {
        return [CommentEntry(textInput)];
      } else {
        return entries;
      }
    }
  }

  List<PageEntry> _findAllTheParameterEntries({required String inside}) {
    List<String> textArr = inside.split(" ");
    List<PageEntry> ret = [];

    for (String textElement in textArr) {
      if (_daqWidget.isACNETDRF(textElement) ||
          _daqWidget.isProcessVariable(textElement)) {
        ret.add(ParameterEntry(textElement,
            label: "", key: Key("parameter_row_$textElement")));
      }
    }

    return ret;
  }

  bool _isMult(String val) {
    RegExp multRegExp = RegExp(r"^mult:\d", caseSensitive: false);
    return multRegExp.hasMatch(val);
  }

  bool _isHardComment(String val) {
    return "!" == val[0];
  }

  String _stripBang(String textInput) {
    return textInput.substring(1);
  }
}
