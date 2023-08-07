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
    onSuccess.call([]);
  }

  static const _testPages = [
    {"pageid": "1", "title": 'west tower'},
    {"pageid": "2", "title": 'east tower'},
    {"pageid": "3", "title": 'Test Page 1'}
  ];
}
