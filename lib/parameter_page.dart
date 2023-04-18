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

  final List<PageEntry> _entries = [];
}
