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
    List<String> textArr = textInput.split(" ");
    List<PageEntry> pageEntries = [];

    if (_isHardComment(textInput)) {
      pageEntries.add(CommentEntry(_stripBang(textInput)));
    } else {
      for (String textElement in textArr) {
        if (_daqWidget.isACNETDRF(textElement) ||
            _daqWidget.isProcessVariable(textElement)) {
          pageEntries.add(ParameterEntry(textElement,
              label: "", key: Key("parameter_row_$textElement")));
        }
      }
    }

    if (pageEntries.isEmpty && textInput.length > 1) {
      pageEntries.add(CommentEntry(textInput));
    }

    return pageEntries;
  }

  bool _isHardComment(String val) {
    return "!" == val[0];
  }

  String _stripBang(String textInput) {
    return textInput.substring(1);
  }
}
