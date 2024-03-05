import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

class MultEntryWidget extends StatelessWidget {
  final int numberOfEntries;
  final String description;

  const MultEntryWidget(
      {super.key, required this.numberOfEntries, this.description = ""});

  @override
  Widget build(BuildContext context) {
    return PageEntryWidget(
        child: Text("mult:$numberOfEntries $description",
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)));
  }
}
