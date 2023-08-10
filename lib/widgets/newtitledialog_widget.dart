import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:parameter_page/parameter_page_service.dart';

class NewTitleDialog extends StatefulWidget {
  final List<dynamic> titles;
  final Function fetchData;
  final ParameterPageService service;

  const NewTitleDialog(
      {Key? key,
      required this.titles,
      required this.fetchData,
      required this.service})
      : super(key: key);

  @override
  State<NewTitleDialog> createState() => _NewTitleDialogState();
}

class _NewTitleDialogState extends State<NewTitleDialog> {
  final Logger logger = Logger();
  final TextEditingController textEditingController = TextEditingController();
  String _hiddenmsg = '';

  @override
  Widget build(BuildContext dialogContext) {
    return AlertDialog(
      title: const Text('Enter new title (1~50 characters)'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const Key("add_page_title"),
            autofocus: true,
            maxLength: 50,
            controller: textEditingController,
            decoration: const InputDecoration(
              hintText: 'Enter value',
            ),
          ),
          Text(_hiddenmsg, style: const TextStyle(color: Colors.red)),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(dialogContext); // Close the dialog
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            List<String> titleList = widget.titles
                .map((record) => record['title'] as String)
                .toList();
            String newTitle = textEditingController.text.trim();
            if (newTitle.trim().isEmpty) {
              setState(() {
                _hiddenmsg = 'title name cannot be blank...';
              });
            } else if (!titleList.contains(newTitle)) {
              Navigator.pop(dialogContext); // Close the dialog
              _addTitle(newTitle);
            } else {
              setState(() {
                _hiddenmsg = '$newTitle already exists...';
              });
            }
          },
        ),
      ],
    );
  }

  Future<void> _addTitle(String title) async {
    widget.service.createPage(
        withTitle: title,
        onFailure: (String errorMessage) {
          logger.e('GraphQL Error: $errorMessage');
        },
        onSuccess: () {
          widget.fetchData();
        });
  } //addtitle function
}
