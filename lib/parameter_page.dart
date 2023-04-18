import 'package:parameter_page/page/entry.dart';

class ParameterPage {
  ParameterPage([List<PageEntry>? entries]) : _entries = entries ?? [];

  void add(PageEntry entry) {
    if (!_editing) {
      throw Exception(
          "Can not modify a ParameterPage when edit mode is disabled.");
    }
    _entries.add(entry);
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

  void cancelEditing() {
    _entries = List<PageEntry>.from(_undoEntries);
    _editing = false;
  }

  List<PageEntry> _entries;

  List<PageEntry> _undoEntries = [];

  bool _editing = false;
}
