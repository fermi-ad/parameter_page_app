import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final List<PageEntry> entries;

  MultEntryWidget({
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
    return KeyboardListener(
        autofocus: enabled,
        focusNode: _focusNode,
        onKeyEvent: enabled ? _onKey : null,
        child: PageEntryWidget(
            child: editMode
                ? _buildEditMode(context)
                : _buildDisplayMode(context)));
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
                          _buildSubEntries(context)
                        ])))));
  }

  Widget _buildEntryText(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text("mult:$numberOfEntries $description",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: colorScheme.secondary));
  }

  Widget _buildSubEntries(BuildContext context) {
    List<Widget> children = [];

    for (final entry in entries) {
      final widget = entry.buildEntry(context, editMode, true, displaySettings,
          false, false, () {}, _knobbingStreamController.stream);

      children.add(widget);
    }

    return Column(children: children);
  }

  void _onKey(KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.f5) {
        _knobParametersUp();
      } else if (event.logicalKey == LogicalKeyboardKey.f4) {
        _knobParametersDown();
      }
    }
  }

  void _knobParametersUp() {
    _knobbingStreamController.add(1.0);
  }

  void _knobParametersDown() {
    _knobbingStreamController.add(-1.0);
  }

  final FocusNode _focusNode = FocusNode();

  final _knobbingStreamController = StreamController<double>.broadcast();
}
