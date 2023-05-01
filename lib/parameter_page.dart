import 'package:flutter/foundation.dart';
import 'package:parameter_page/page_entry.dart';

class ParameterPage {
  ParameterPage([List<PageEntry>? entries])
      : _entries = List<PageEntry>.from(entries ?? []),
        _savedEntries = List<PageEntry>.from(entries ?? []);

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
  }

  void disableEditing() {
    _editing = false;
  }

  void toggleEditing() {
    _editing ? disableEditing() : enableEditing();
  }

  void cancelEditing() {
    _entries = List<PageEntry>.from(_undoEntries);
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

  bool get isDirty {
    return !listEquals<PageEntry>(_entries, _savedEntries);
  }

  List<PageEntry> _entries;

  List<PageEntry> _undoEntries = [];

  final List<PageEntry> _savedEntries;

  bool _editing = false;
}
