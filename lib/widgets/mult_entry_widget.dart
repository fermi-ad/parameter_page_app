import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

class MultEntryWidget extends StatelessWidget {
  final String text;

  const MultEntryWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return PageEntryWidget(
        child: Text(text,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary)));
  }
}
