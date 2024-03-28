import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

class MultEntryWidget extends StatelessWidget {
  final int numberOfEntries;

  final String description;

  final bool editMode;

  final bool enabled;

  final VoidCallback? onTap;

  final bool settingsAllowed;

  const MultEntryWidget(
      {super.key,
      required this.numberOfEntries,
      this.description = "",
      this.onTap,
      this.enabled = false,
      this.editMode = false,
      this.settingsAllowed = false});

  @override
  Widget build(BuildContext context) {
    return PageEntryWidget(
        child: editMode ? _buildEditMode(context) : _buildDisplayMode(context));
  }

  Widget _buildEditMode(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 36.0),
        child: _buildEntryText(context));
  }

  Widget _buildDisplayMode(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
        onTap: settingsAllowed ? onTap : null,
        child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: enabled
                        ? colorScheme.secondaryContainer
                        : colorScheme.surface,
                    width: 2.0),
                borderRadius: BorderRadius.circular(15.0)),
            child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 34.0),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20.0),
                    child: Column(children: [
                      _buildEntryText(context),
                      _buildParameters(context)
                    ])))));
  }

  Widget _buildEntryText(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text("mult:$numberOfEntries $description",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: colorScheme.secondary));
  }

  Widget _buildParameters(BuildContext context) {
    return const Text("Parameters will go here");
  }
}