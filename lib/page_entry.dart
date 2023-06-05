import 'package:flutter/material.dart';

import 'widgets/comment_entry_widget.dart';
import 'widgets/display_settings_widget.dart';
import 'widgets/parameter_widget.dart';

// Base class for the Entry class hierarchy.

abstract class PageEntry {
  final Key key;

  // The base class takes an optional 'key' parameter. If it
  // isn't provided a key, it'll use `UniqueKey()`.

  PageEntry({Key? key}) : key = key ?? UniqueKey();

  Widget buildEntry(
      BuildContext context, bool editMode, bool wide, DisplaySettings settings);

  @override
  bool operator ==(other) {
    return (other is PageEntry) && entryText() == other.entryText();
  }

  @override
  int get hashCode => entryText().hashCode;

  String entryText();
}

class CommentEntry extends PageEntry {
  final String text;

  CommentEntry(this.text, {Key? key}) : super(key: key);

  @override
  Widget buildEntry(BuildContext context, bool editMode, bool wide,
      DisplaySettings settings) {
    return CommentEntryWidget(text);
  }

  @override
  String entryText() => text;
}

class ParameterEntry extends PageEntry {
  final String drf;
  final String? label;

  ParameterEntry(this.drf, {this.label, super.key});

  @override
  Widget buildEntry(BuildContext context, bool editMode, bool wide,
      DisplaySettings settings) {
    return ParameterWidget(
        drf: drf,
        editMode: editMode,
        wide: wide,
        displayUnits: settings.units,
        displayAlarmDetails: settings.showAlarmDetails,
        label: label,
        key: key);
  }

  @override
  String entryText() => drf;
}
