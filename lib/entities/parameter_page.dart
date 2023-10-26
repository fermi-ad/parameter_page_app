import 'package:flutter/foundation.dart';
import 'package:parameter_page/entities/page_entry.dart';

class ParameterPage {
  String? id;

  set title(String newTitle) {
    _enforceEditMode();
    _title = newTitle;
  }

  String get title {
    return _title;
  }

  List<String> tabTitles = ["Tab 1"];

  ParameterPage([List<PageEntry>? entries])
      : _entries = List<PageEntry>.from(entries ?? []),
        _savedEntries = List<PageEntry>.from(entries ?? []);

  ParameterPage.fromQueryResult(
      {required this.id,
      required String title,
      required List<dynamic> queryResult})
      : _entries = [],
        _savedEntries = [] {
    final initialEntries = _buildEntriesListFromQueryResult(queryResult);

    _entries = List<PageEntry>.from(initialEntries);
    _savedEntries = List<PageEntry>.from(initialEntries);

    _title = title;
    _savedTitle = title;
  }

  void add(PageEntry entry) {
    _enforceEditMode();
    _entries.add(entry);
  }

  void _enforceEditMode() {
    if (!_editing) {
      throw Exception(
          "Can not modify a ParameterPage when edit mode is disabled.");
    }
  }

  List<PageEntry> entriesAsList() {
    return _entries;
  }

  int get numberOfEntries {
    return _entries.length;
  }

  bool editing() {
    return _editing;
  }

  void enableEditing() {
    _editing = true;
    _undoEntries = List<PageEntry>.from(_entries);
    _undoTitle = _title;
  }

  void disableEditing() {
    _editing = false;
  }

  void toggleEditing() {
    _editing ? disableEditing() : enableEditing();
  }

  void cancelEditing() {
    _entries = List<PageEntry>.from(_undoEntries);
    _title = _undoTitle;
    _editing = false;
  }

  void reorderEntry({required int atIndex, required int toIndex}) {
    _enforceEditMode();

    if (atIndex < toIndex) {
      toIndex -= 1;
    }
    final PageEntry entry = _entries.removeAt(atIndex);
    _entries.insert(toIndex, entry);
  }

  void removeEntry({required int at}) {
    _enforceEditMode();

    _entries.removeAt(at);
  }

  void clearAll() {
    _enforceEditMode();

    _entries = [];
  }

  void commit() {
    _savedEntries = List<PageEntry>.from(_entries);
    _savedTitle = title;
  }

  bool get isDirty {
    return title != _savedTitle ||
        !listEquals<PageEntry>(_entries, _savedEntries);
  }

  List<PageEntry> _buildEntriesListFromQueryResult(List<dynamic> queryResult) {
    List<PageEntry> ret = [];
    for (final entryData in queryResult) {
      ret.add(_hydratePageEntry(from: entryData));
    }

    return ret;
  }

  PageEntry _hydratePageEntry({required Map<String, dynamic> from}) {
    switch (from["type"]) {
      case "Comment":
      case "Comments":
        return CommentEntry(from["text"]!, id: from["entryid"]);

      case "Parameter":
        return ParameterEntry(from["text"], id: from["entryid"]);

      case "Expression":
        return CommentEntry(from["text"]!, id: from["entryid"]);

      default:
        throw UnimplementedError("Unexpected PageEntry type");
    }
  }

  List<PageEntry> _entries;

  List<PageEntry> _undoEntries = [];

  List<PageEntry> _savedEntries;

  String _title = "New Parameter Page";

  String _undoTitle = "New Parameter Page";

  String _savedTitle = "New Parameter Page";

  bool _editing = false;
}
