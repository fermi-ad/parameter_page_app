import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/mult_entry_widget.dart';

import '../widgets/comment_entry_widget.dart';
import '../widgets/display_settings_widget.dart';
import '../widgets/parameter_widget.dart';

// Base class for the Entry class hierarchy.

abstract class PageEntry {
  final Key key;

  String? id;

  // The base class takes an optional 'key' parameter. If it
  // isn't provided a key, it'll use `UniqueKey()`.

  PageEntry({Key? key, this.id}) : key = key ?? UniqueKey();

  Widget buildEntry(
      BuildContext context,
      bool editMode,
      bool wide,
      DisplaySettings settings,
      bool settingsAllowed,
      bool hasFocus,
      VoidCallback? onTap,
      Stream<double>? knobbingStream);

  @override
  bool operator ==(other) {
    return (other is PageEntry) && entryText() == other.entryText();
  }

  @override
  int get hashCode => entryText().hashCode;

  String entryText();

  String get typeAsString => "PageEntry";

  double get proportion => 0;
}

class MultEntry extends PageEntry {
  final int numberOfEntries;

  final String description;

  final List<PageEntry> subEntries = [];

  MultEntry(
      {super.key,
      super.id,
      required this.numberOfEntries,
      this.description = ""});

  @override
  Widget buildEntry(
      BuildContext context,
      bool editMode,
      bool wide,
      DisplaySettings settings,
      bool settingsAllowed,
      bool hasFocus,
      VoidCallback? onTap,
      Stream<double>? knobbingStream) {
    return MultEntryWidget(
        numberOfEntries: numberOfEntries,
        description: description,
        editMode: editMode,
        enabled: hasFocus,
        onTap: onTap,
        entries: subEntries,
        settingsAllowed: settingsAllowed,
        displaySettings: settings);
  }

  @override
  String entryText() => description.isNotEmpty
      ? "mult:$numberOfEntries $description"
      : "mult:$numberOfEntries";

  @override
  String get typeAsString => "Mult";
}

class CommentEntry extends PageEntry {
  final String text;

  CommentEntry(this.text, {super.key, super.id});

  @override
  Widget buildEntry(
      BuildContext context,
      bool editMode,
      bool wide,
      DisplaySettings settings,
      bool settingsAllowed,
      bool hasFocus,
      VoidCallback? onTap,
      Stream<double>? knobbingStream) {
    return CommentEntryWidget(text);
  }

  @override
  String entryText() => text;

  @override
  String get typeAsString => "Comments";
}

class ParameterEntry extends PageEntry {
  final String drf;
  final String? label;

  ParameterEntry(this.drf, {this.label, super.key, super.id});

  @override
  Widget buildEntry(
      BuildContext context,
      bool editMode,
      bool wide,
      DisplaySettings settings,
      bool settingsAllowed,
      bool hasFocus,
      VoidCallback? onTap,
      Stream<double>? knobbingStream) {
    return ParameterWidget(
        drf: drf,
        settingsAllowed: settingsAllowed,
        editMode: editMode,
        wide: wide,
        displayUnits: settings.units,
        displayAlarmDetails: settings.showAlarmDetails,
        label: label,
        knobbingStream: knobbingStream,
        key: Key("parameter_row_$drf"));
  }

  @override
  String entryText() => drf;

  @override
  String get typeAsString => "Parameter";
}
