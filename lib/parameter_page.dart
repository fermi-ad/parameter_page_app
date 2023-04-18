import 'package:parameter_page/page/entry.dart';

class ParameterPage {
  PageEntry createEntry(String newEntryText) {
    PageEntry newEntry = CommentEntry(newEntryText);
    _entries.add(CommentEntry(newEntryText));
    return newEntry;
  }

  List<PageEntry> entriesAsList() {
    return _entries;
  }

  int numberOfEntries() {
    return _entries.length;
  }

  final List<PageEntry> _entries = [];
}
