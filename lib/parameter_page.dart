import 'package:parameter_page/page/entry.dart';

class ParameterPage {
  void add(PageEntry entry) {
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
  }

  void disableEditing() {
    _editing = false;
  }

  final List<PageEntry> _entries = [];

  bool _editing = false;
}
