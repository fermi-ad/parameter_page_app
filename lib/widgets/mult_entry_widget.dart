import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

class MultEntryWidget extends StatelessWidget {
  final int numberOfEntries;
  final String description;

  const MultEntryWidget(
      {super.key, required this.numberOfEntries, this.description = ""});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PageEntryWidget(
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: colorScheme.surface, width: 2.0),
                borderRadius: BorderRadius.circular(4.0)),
            child: Text("mult:$numberOfEntries $description",
                style: TextStyle(color: colorScheme.secondary))));
  }
}
