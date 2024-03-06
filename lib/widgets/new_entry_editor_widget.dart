import 'package:flutter/material.dart';
import 'package:parameter_page/entities/page_entry_factory.dart';

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
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
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

          widget.onSubmitted(_pageEntryFactory.createEntries(fromInput: value));
        });
  }

  final _pageEntryFactory = PageEntryFactory();
}
