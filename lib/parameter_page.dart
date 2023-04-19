import 'package:parameter_page/page/entry.dart';

class ParameterPage {
  ParameterPage([List<PageEntry>? entries]) : _entries = entries ?? [];

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

  int numberOfEntries() {
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

  List<PageEntry> _entries;

  List<PageEntry> _undoEntries = [];

  bool _editing = false;
}
