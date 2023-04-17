import 'package:parameter_page/page/entry.dart';

class ParameterPage {
  void createEntry(String newEntry) {
    _entries.add(CommentEntry(newEntry));
  }

  List<PageEntry> entriesAsList() {
    return _entries;
  }

  int numberOfEntries() {
    return _entries.length;
  }

  final List<PageEntry> _entries = [];
}
