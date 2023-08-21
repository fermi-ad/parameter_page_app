import 'dart:async';

import 'package:parameter_page/entities/page_entry.dart';
import 'package:parameter_page/entities/parameter_page.dart';
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

  @override
  Future<void> savePage(
      {required String id,
      required ParameterPage page,
      required Function() onSuccess}) async {
    final entries = page.entriesAsList();

    List<Map<String, String>> newEntries = [];
    int position = 0;
    for (final PageEntry entry in entries) {
      newEntries.add({
        "pageid": id,
        "entryid": DateTime.now().microsecondsSinceEpoch.toString(),
        "position": "$position",
        "text": entry.entryText(),
        "type": entry is CommentEntry ? "Comment" : "Parameter"
      });
      position += 1;
    }

    _testPageEntries[id] = newEntries;

    Timer(const Duration(seconds: 1), () => onSuccess.call());
  }

  final _testPages = [
    {"pageid": "1", "title": 'east tower'},
    {"pageid": "2", "title": 'west tower'},
    {"pageid": "4", "title": "Test Page 1"},
    {"pageid": "3", "title": 'Test Page 2'}
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
    ],
    "4": [
      {
        "entryid": "6",
        "pageid": "4",
        "position": "0",
        "text": "M:OUTTMP@e,02",
        "type": "Parameter"
      },
      {
        "entryid": "7",
        "pageid": "4",
        "position": "1",
        "text": "This is our first comment!",
        "type": "Comment"
      },
      {
        "entryid": "8",
        "pageid": "4",
        "position": "2",
        "text": "G:AMANDA",
        "type": "Parameter"
      },
      {
        "entryid": "9",
        "pageid": "4",
        "position": "3",
        "text": "Z:NO_ALARMS",
        "type": "Parameter"
      },
      {
        "entryid": "10",
        "pageid": "4",
        "position": "4",
        "text": "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE",
        "type": "Parameter"
      },
      {
        "entryid": "11",
        "pageid": "4",
        "position": "5",
        "text": "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:HUMIDITY",
        "type": "Parameter"
      },
      {
        "entryid": "12",
        "pageid": "4",
        "position": "6",
        "text": "Z:BTE200_TEMP",
        "type": "Parameter"
      },
      {
        "entryid": "13",
        "pageid": "4",
        "position": "7",
        "text": "Z:INC_SETTING",
        "type": "Parameter"
      }
    ]
  };
}
