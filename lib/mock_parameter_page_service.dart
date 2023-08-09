import 'package:parameter_page/parameter_page_service.dart';

class MockParameterPageService extends ParameterPageService {
  @override
  Future<void> fetchPages(
      {required Function(String errorMessage) onFailure,
      required Function(List pageTitles) onSuccess}) async {
    onSuccess.call(_testPages);
  }

  @override
  Future<void> fetchEntries(
      {required String forPageId,
      required Function(String errorMessage) onFailure,
      required Function(List entries) onSuccess}) async {
    onSuccess.call(_testPageEntries[forPageId]!);
  }

  static const _testPages = [
    {"pageid": "1", "title": 'east tower'},
    {"pageid": "2", "title": 'west tower'},
    {"pageid": "3", "title": 'Test Page 1'}
  ];

  static const _testPageEntries = {
    "1": [
      {
        "entryid": "1",
        "pageid": "1",
        "position": "0",
        "text": "this is entry to east tower",
        "type": "Comment"
      },
      {
        "entryid": "2",
        "pageid": "1",
        "position": "1",
        "text": "graph route",
        "type": "Comment"
      },
      {
        "entryid": "3",
        "pageid": "1",
        "position": "2",
        "text": "graph route",
        "type": "Comment"
      }
    ]
  };
}
