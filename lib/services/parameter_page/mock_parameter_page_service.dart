import 'dart:async';

import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';

class MockParameterPageService extends ParameterPageService {
  @override
  Future<void> fetchPages(
      {required Function(String errorMessage) onFailure,
      required Function(List pageTitles) onSuccess}) async {
    Timer(const Duration(seconds: 1), () => onSuccess.call(_testPages));
  }

  @override
  Future<void> fetchEntries(
      {required String forPageId,
      required Function(String errorMessage) onFailure,
      required Function(List entries) onSuccess}) async {
    Timer(const Duration(seconds: 1),
        () => onSuccess.call(_testPageEntries[forPageId]!));
  }

  @override
  Future<void> createPage(
      {required String withTitle,
      required Function(String errorMessage) onFailure,
      required Function() onSuccess}) async {
    _testPages.add({"pageid": "4", "title": withTitle});
    _testPageEntries["4"] = [
      {
        "entryid": "4",
        "pageid": "4",
        "position": "0",
        "text": "position #0",
        "type": "Comment"
      }
    ];
    onSuccess.call();
  }

  @override
  Future<void> deletePage(
      {required String withPageId,
      required Function(String errorMessage) onFailure,
      required Function() onSuccess}) async {
    for (var page in _testPages) {
      if (page["pageid"] == withPageId) {
        _testPages.remove(page);

        onSuccess.call();

        return;
      }
    }

    onFailure.call("page could not be deleted (pageid not found)");
  }

  final _testPages = [
    {"pageid": "1", "title": 'east tower'},
    {"pageid": "2", "title": 'west tower'},
    {"pageid": "3", "title": 'Test Page 1'}
  ];

  final _testPageEntries = {
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
    ],
    "3": [
      {
        "entryid": "4",
        "pageid": "3",
        "position": "0",
        "text": "this is comment #1",
        "type": "Comment"
      },
      {
        "entryid": "5",
        "pageid": "3",
        "position": "1",
        "text": "I:BEAM",
        "type": "Parameter"
      },
      {
        "entryid": "6",
        "pageid": "3",
        "position": "2",
        "text": "R:BEAM",
        "type": "Parameter"
      },
      {
        "entryid": "5",
        "pageid": "3",
        "position": "1",
        "text": "this is comment #2",
        "type": "Comment"
      }
    ]
  };
}
