import 'dart:async';

import 'package:parameter_page/entities/page_entry.dart';
import 'package:parameter_page/entities/parameter_page.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';

class MockParameterPageService extends ParameterPageService {
  bool fetchPagesShouldFail = false;

  bool fetchPageShouldFail = false;

  bool createPageShouldFail = false;

  bool savePageShouldFail = false;

  bool renamePageShouldFail = false;

  @override
  Future<void> fetchPages(
      {required Function(String errorMessage) onFailure,
      required Function(List pageTitles) onSuccess}) async {
    Timer(
        const Duration(seconds: 1),
        fetchPagesShouldFail
            ? () => onFailure.call("Fake fetchPages error message.")
            : () => onSuccess.call(_testPages));
  }

  @override
  Future<String> createPage({required String withTitle}) async {
    if (createPageShouldFail) {
      return Future.error("Fake createPage() failure.");
    }

    int newPageId = _testPages.length + 1;
    _testPages.add({"pageid": "$newPageId", "title": withTitle});
    _testPageEntries["$newPageId"] = {
      "tabs": [
        {"title": "Tab 1", "entries": []}
      ]
    };

    return "$newPageId";
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
    if (savePageShouldFail) {
      return Future.error("Fake savePage failure.");
    }

    _testPageEntries[id] = {"tabs": []};
    for (final tabTitle in page.tabTitles) {
      final entries = page.entriesAsList(forTab: tabTitle);

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

      _testPageEntries[id]!["tabs"]!
          .add({"title": tabTitle, "entries": newEntries});
    }

    Timer(const Duration(seconds: 1), () => onSuccess.call());
  }

  @override
  Future<String> renamePage(
      {required String id, required String newTitle}) async {
    if (renamePageShouldFail) {
      return Future.error("Fake renamePage failure.");
    }

    for (Map<String, String> page in _testPages) {
      if (page["pageid"] == id) {
        page["title"] = newTitle;
        return newTitle;
      }
    }

    return Future.error("Failed to rename page");
  }

  @override
  Future<ParameterPage> fetchPage({required String id}) async {
    if (fetchPageShouldFail) {
      return Future.error("Fake failure for fetchPage.");
    }

    for (Map<String, String> page in _testPages) {
      if (page["pageid"] == id) {
        String title = page["title"]!;
        final entries = _testPageEntries[id]!;
        return ParameterPage.fromQueryResult(
            id: id, title: title, queryResult: entries);
      }
    }

    return Future.error("Failed to load page id: $id");
  }

  final _testPages = [
    {"pageid": "1", "title": 'east tower'},
    {"pageid": "2", "title": 'west tower'},
    {"pageid": "4", "title": "Test Page 1"},
    {"pageid": "3", "title": 'Test Page 2'},
    {"pageid": "5", "title": "Eight Tabs"}
  ];

  final _testPageEntries = {
    "1": {
      "tabs": [
        {
          "title": "Tab 1",
          "sub-pages": [
            {
              "id": "1",
              "title:": "",
              "entries": [
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
            }
          ]
        }
      ]
    },
    "3": {
      "tabs": [
        {
          "title": "Tab 1",
          "sub-pages": [
            {
              "id": "1",
              "title": "",
              "entries": [
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
            }
          ]
        },
        {
          "title": "Tab 2",
          "sub-pages": [
            {
              "id": "1",
              "title": "",
              "entries": [
                {
                  "entryid": "16",
                  "pageid": "3",
                  "position": "0",
                  "text": "This is Tab 2",
                  "type": "Comment"
                }
              ]
            }
          ]
        }
      ]
    },
    "4": {
      "tabs": [
        {
          "title": "Tab 1",
          "sub-pages": [
            {
              "id": "1",
              "title": "",
              "entries": [
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
                },
                {
                  "entryid": "14",
                  "pageid": "4",
                  "position": "8",
                  "text": "Z:NO_SET",
                  "type": "Parameter"
                },
                {
                  "entryid": "15",
                  "pageid": "4",
                  "position": "9",
                  "text": "Z:NO_READ",
                  "type": "Parameter"
                }
              ]
            }
          ]
        }
      ]
    },
    "5": {
      "tabs": [
        {
          "title": "Tab One",
          "sub-pages": [
            {
              "id": "1",
              "title": "",
              "entries": [
                {
                  "entryid": "17",
                  "pageid": "5",
                  "position": "1",
                  "text": "This is Tab One",
                  "type": "Comment"
                }
              ]
            }
          ]
        },
        {
          "title": "Tab Two",
          "sub-pages": [
            {"id": "1", "title": "", "entries": []}
          ]
        },
        {
          "title": "Tab Three",
          "sub-pages": [
            {"id": "1", "title": "", "entries": []}
          ]
        },
        {
          "title": "Tab Four",
          "sub-pages": [
            {"id": "1", "title": "", "entries": []}
          ]
        },
        {
          "title": "Tab Five",
          "sub-pages": [
            {"id": "1", "title": "", "entries": []}
          ]
        },
        {
          "title": "Tab Six",
          "sub-pages": [
            {"id": "1", "title": "", "entries": []}
          ]
        },
        {
          "title": "Tab Seven",
          "sub-pages": [
            {"id": "1", "title": "", "entries": []}
          ]
        },
        {
          "title": "Tab Eight",
          "sub-pages": [
            {"id": "1", "title": "", "entries": []}
          ]
        },
      ]
    }
  };
}
