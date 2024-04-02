import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/display_settings_widget.dart';
import 'package:parameter_page/widgets/page_entry_widget.dart';

import '../entities/page_entry.dart';

class MultEntryWidget extends StatelessWidget {
  final int numberOfEntries;

  final String description;

  final bool editMode;

  final bool enabled;

  final VoidCallback? onTap;

  final bool settingsAllowed;

  final DisplaySettings displaySettings;

  final List<String> entries;

  const MultEntryWidget({
    super.key,
    required this.numberOfEntries,
    this.description = "",
    required this.displaySettings,
    required this.entries,
    this.onTap,
    this.enabled = false,
    this.editMode = false,
    this.settingsAllowed = false,
  });

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
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
    List<Widget> children = [];
    for (final drf in entries) {
      children.add(ParameterEntry(drf).buildEntry(
          context, editMode, true, displaySettings, false, false, () {}));
    }

    return Column(children: children);
  }
}
