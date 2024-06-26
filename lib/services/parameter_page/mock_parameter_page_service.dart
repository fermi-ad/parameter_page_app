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
  Future<List<dynamic>> fetchPages() async {
    return Future<List<dynamic>>.delayed(const Duration(seconds: 1), () {
      if (fetchPagesShouldFail) {
        throw Exception("Fake fetchPages error message.");
      } else {
        return _testPages;
      }
    });
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
  Future<void> deletePage({required String withPageId}) async {
    for (var page in _testPages) {
      if (page["pageid"] == withPageId) {
        _testPages.remove(page);
        return;
      }
    }

    return Future.error("page could not be deleted (pageid not found)");
  }

  @override
  Future<void> savePage(
      {required String id, required ParameterPage page}) async {
    if (savePageShouldFail) {
      return Future.error("Fake savePage failure.");
    }

    _testPageEntries[id] = {
      "sub_systems": [
        {"title": "Sub-system 1", "tabs": <Map<String, dynamic>>[]}
      ]
    };
    for (final tabTitle in page.tabTitles) {
      List<Map<String, dynamic>> newSubPages = [];

      for (int i = 0; i != page.subPageCount(forTab: tabTitle); i++) {
        final entries = page.entriesAsListFrom(tab: tabTitle, subPage: i + 1);

        List<Map<String, String>> newEntries = [];
        int position = 0;
        for (final PageEntry entry in entries) {
          newEntries.add({
            "pageid": id,
            "entryid": DateTime.now().microsecondsSinceEpoch.toString(),
            "proportion": "${entry.proportion}",
            "position": "$position",
            "text": entry.entryText(),
            "type": entry.typeAsString,
            "numberOfEntries":
                entry is MultEntry ? "${entry.numberOfEntries}" : "0",
            "description": entry is MultEntry ? entry.description : ""
          });
          position += 1;
        }

        newSubPages.add({
          "id": "$i",
          "title": page.subPageTitleFor(tab: tabTitle, subPageIndex: i + 1),
          "entries": newEntries
        });
      }

      (_testPageEntries[id]!["sub_systems"]![0]["tabs"]! as List<dynamic>)
          .add({"title": tabTitle, "sub_pages": newSubPages});
    }

    return Future<void>.delayed(const Duration(seconds: 1), () {});
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
      "sub_systems": [
        {
          "title": "Sub-system 1",
          "tabs": [
            {
              "title": "Tab 1",
              "sub_pages": [
                {
                  "id": "1",
                  "title:": "",
                  "entries": [
                    {
                      "entryid": "1",
                      "pageid": "1",
                      "position": "0",
                      "proportion": "1.0",
                      "text": "this is entry to east tower",
                      "type": "Comment"
                    },
                    {
                      "entryid": "2",
                      "pageid": "1",
                      "position": "1",
                      "proportion": "1.0",
                      "text": "graph route",
                      "type": "Comment"
                    },
                    {
                      "entryid": "3",
                      "pageid": "1",
                      "position": "2",
                      "proportion": "1.0",
                      "text": "graph route",
                      "type": "Comment"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    "3": {
      "sub_systems": [
        {
          "title": "Sub-system 1",
          "tabs": [
            {
              "title": "Tab 1",
              "sub_pages": [
                {
                  "id": "1",
                  "title": "Sub-Page One",
                  "entries": [
                    {
                      "entryid": "4",
                      "pageid": "3",
                      "position": "0",
                      "proportion": "1.0",
                      "text": "this is comment #1",
                      "type": "Comment"
                    },
                    {
                      "entryid": "5",
                      "pageid": "3",
                      "position": "1",
                      "proportion": "1.0",
                      "text": "I:BEAM",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "6",
                      "pageid": "3",
                      "position": "2",
                      "proportion": "1.0",
                      "text": "R:BEAM",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "5",
                      "pageid": "3",
                      "position": "1",
                      "proportion": "1.0",
                      "text": "this is comment #2",
                      "type": "Comment"
                    }
                  ]
                },
                {
                  "id": "2",
                  "title": "Sub-Page Two",
                  "entries": [
                    {
                      "entryid": "7",
                      "pageid": "3",
                      "position": "1",
                      "proportion": "1.0",
                      "text": "this is comment #3",
                      "type": "Comment"
                    }
                  ]
                },
                {
                  "id": "3",
                  "entries": [
                    {
                      "entryid": "17",
                      "pageid": "3",
                      "position": "1",
                      "proportion": "1.0",
                      "text": "this sub-page has no title",
                      "type": "Comment"
                    }
                  ]
                }
              ]
            },
            {
              "title": "Tab 2",
              "sub_pages": [
                {
                  "id": "1",
                  "title": "",
                  "entries": [
                    {
                      "entryid": "16",
                      "pageid": "3",
                      "position": "0",
                      "proportion": "1.0",
                      "text": "This is Tab 2",
                      "type": "Comment"
                    }
                  ]
                }
              ]
            }
          ]
        },
        {
          "title": "Sub-system 2",
          "tabs": [
            {
              "title": "Tab 1",
              "sub_pages": [
                {
                  "id": "1",
                  "title": "Sub-Page One",
                  "entries": [
                    {
                      "entryid": "4",
                      "pageid": "3",
                      "position": "0",
                      "proportion": "1.0",
                      "text": "this is Sub-system 2 / Tab 1 / Sub-page One",
                      "type": "Comment"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    "4": {
      "sub_systems": [
        {
          "title": "Sub-system 1",
          "tabs": [
            {
              "title": "Tab 1",
              "sub_pages": [
                {
                  "id": "1",
                  "title": "",
                  "entries": [
                    {
                      "entryid": "6",
                      "pageid": "4",
                      "position": "0",
                      "proportion": "1.0",
                      "text": "M:OUTTMP@e,02",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "7",
                      "pageid": "4",
                      "position": "1",
                      "proportion": "1.0",
                      "text": "This is our first comment!",
                      "type": "Comment"
                    },
                    {
                      "entryid": "8",
                      "pageid": "4",
                      "position": "2",
                      "proportion": "1.0",
                      "text": "G:AMANDA",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "9",
                      "pageid": "4",
                      "position": "3",
                      "proportion": "1.0",
                      "text": "Z:NO_ALARMS",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "10",
                      "pageid": "4",
                      "position": "4",
                      "proportion": "1.0",
                      "text": "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:TEMPERATURE",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "11",
                      "pageid": "4",
                      "position": "5",
                      "proportion": "1.0",
                      "text": "PIP2:SSR1:SUBSYSTEMA:SUBSUBSYSTEM:HUMIDITY",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "12",
                      "pageid": "4",
                      "position": "6",
                      "proportion": "1.0",
                      "text": "Z:BTE200_TEMP",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "13",
                      "pageid": "4",
                      "position": "7",
                      "proportion": "1.0",
                      "text": "Z:INC_SETTING",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "14",
                      "pageid": "4",
                      "position": "8",
                      "proportion": "1.0",
                      "text": "Z:NO_SET",
                      "type": "Parameter"
                    },
                    {
                      "entryid": "15",
                      "pageid": "4",
                      "position": "9",
                      "proportion": "1.0",
                      "text": "Z:NO_READ",
                      "type": "Parameter"
                    }
                  ]
                }
              ]
            }
          ]
        }
      ]
    },
    "5": {
      "sub_systems": [
        {
          "title": "Sub-system 1",
          "tabs": [
            {
              "title": "Tab One",
              "sub_pages": [
                {
                  "id": "1",
                  "title": "",
                  "entries": [
                    {
                      "entryid": "17",
                      "pageid": "5",
                      "position": "1",
                      "proportion": "1.0",
                      "text": "This is Tab One",
                      "type": "Comment"
                    }
                  ]
                }
              ]
            },
            {
              "title": "Tab Two",
              "sub_pages": [
                {"id": "1", "title": "", "entries": []}
              ]
            },
            {
              "title": "Tab Three",
              "sub_pages": [
                {"id": "1", "title": "", "entries": []}
              ]
            },
            {
              "title": "Tab Four",
              "sub_pages": [
                {"id": "1", "title": "", "entries": []}
              ]
            },
            {
              "title": "Tab Five",
              "sub_pages": [
                {"id": "1", "title": "", "entries": []}
              ]
            },
            {
              "title": "Tab Six",
              "sub_pages": [
                {"id": "1", "title": "", "entries": []}
              ]
            },
            {
              "title": "Tab Seven",
              "sub_pages": [
                {"id": "1", "title": "", "entries": []}
              ]
            },
            {
              "title": "Tab Eight",
              "sub_pages": [
                {"id": "1", "title": "", "entries": []}
              ]
            },
          ]
        }
      ]
    }
  };
}
