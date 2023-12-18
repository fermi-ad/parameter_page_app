///********************************************************************
/// name: add_defaultpagetree
/// input: parameter page title (string)
/// output: one complete tree structures of single default branche and values
///         of one parameter page, including tree title, one sub-system,
///         one tab, one sub-page, no user entries.
///**********************************************************************
const addDefaultPageTree = r"""
             mutation newDefaultPageTree($title: String!) {
                newParamPage(title: $title) {
                  pageid
                  title
                  sub_systems:subsyslist {
                    subsysid
                    title
                    seqnum
                    tabs:subsystablist {
                      subsystabid
                      title
                      seqnum
                      sub_pages:tabpagelist {
                        tabpageid
                        title
                        seqnum
                      }
                    }
                  }
                }
              }
          """;

///********************************************************************
/// name: add_subsysBranch
/// input: subsys title, seqnum, parent_ParampageId
///       e.g.
///            {
///              "title": "M3 Line",
///              "seqnum": 3,
///              "subsysid": 226
///            }
/// output: one new subsys with subsysId, title, seqnum and its default tab
///         and subpage.
///**********************************************************************
const addSubSysBranch = r"""
           mutation newSubsysBranch($title: String!, $seqnum: Int!, $pageid: ID!) {
              newSubsysBranch(title: $title, seqnum: $seqnum, pageid: $pageid) {
                subsysid
                title
                seqnum
                tabs:subsystablist {
                  subsystabid
                  title
                  seqnum
                  sub_pages:tabpagelist {
                    tabpageid
                    title
                    seqnum
                  }
                }
              }
            }
""";

///********************************************************************
/// name: add_tabBranch
/// input: tab title, seqnum, parent_subsysId,
///       e.g.
///            {
///              "title": "some tab",
///              "seqnum": 2,
///              "subsysid": 12
///            }
/// output: one new tab with tabId, title, seqnum and its default subpage
///**********************************************************************
const addTabBranch = r"""
          mutation newTabBranch($title: String!, $seqnum: Int!, $subsysid: ID!) {
              newSubsysTabBranch(title: $title, seqnum: $seqnum, subsysid: $subsysid) {
                subsystabid
                title
                seqnum
                sub_pages:tabpagelist {
                  tabpageid
                  title
                  seqnum
                }
              }
            }
""";

///********************************************************************
/// name: add_subpage
/// input: subpage title, seqnum, parent_tabId
///       e.g.
///            {
///                "title": "subpage2",
///                "seqnum": 2,
///                "subsystabid": 42
///              }
/// output: one new subpage with subpageId, title, seqnum
///**********************************************************************
const addSubPage = r"""
         mutation newTabPage($title: String, $seqnum: Int!, $subsystabid: ID!) {
              newTabPage(title: $title, seqnum: $seqnum, subsystabid: $subsystabid) {
                tabpageid
                title
                seqnum
              }
            }
""";

///********************************************************************
/// name: merge_entries
///      (use to merge(insert, update or mix of both) those new/updated entries only,
///      IF transaction deletion is included, run delete_entries first)
/// input: list of entries(one or more) to merge, format of
///        [
///            {
///              tabpageid, -- same subpage id for all entries in one list
///              position, -- ending screen position(row#) before submit
///              text_old, -- old value at current position, null for new entry
///              text_new, -- new value for current position, same as old value if no change
///              type_old, -- old value at current position, null for new entry
///              type_new  -- new value for current position, same as old value if no change
///            },
///            {...}
///          ]
///        order the list by position at descending order.
///        e.g.
///                "mrgEntries": [
///            {
///              "tabpageid": 3,
///              "position": 31,
///              "text_old": null,
///              "text_new": "high temperature",
///              "type_old": null,
///              "type_new": "Comments"
///            },
///          {
///              "tabpageid": 3,
///              "position": 21,
///              "text_old": "magnetics",
///              "text_new": "electrical magnetics",
///              "type_old": "Comments",
///              "type_new": "Comments"
///            }
///          ]
/// output: transaction return code and message.
///          (return code, 1: succeed, -1: failed)
///**********************************************************************
const mergeEntries = r"""
          mutation mergeEntries($mrgEntries: [PageEntryUpdInput]!) {
            mergePageEntries(mrgEntries: $mrgEntries) {
              code
              message
            }
          }
      """;

///********************************************************************
/// name: delete_entries
/// input: list of entry Ids(one or more), format of [{tabpageid, position},{...}]
///        e.g.
///        "delEntries": [
///            {"tabpageid": "21", "position": 33},
///            {"tabpageid": "21", "position": 43}
///          ]
/// output: transaction return code and message.
///          (return code, 1: succeed, -1: failed)
///**********************************************************************
const deleteEntries = r"""
          mutation deleteEntries($delEntries: [EntryIdInput]!) {
            deletePageEntries(delEntries: $delEntries) {
              code
              message
            }
          }
""";

///********************************************************************
/// name: update_subjectTitles
/// input: list of titles(one or more) of same subject type, format of
///       {subjecttype, [{subjectId1, title1},{...}]}
///       e.g.
///         {
///            "subjType": "tab",
///             "subjTitles": [
///                {
///                  "subjectid": 7,
///                  "title": "new tab 1",
///                },
///                {
///                  "subjectid": 26,
///                  "title": "new tab 2"
///                }
///              ]
///            }
///         acceptable subject types: parampage, subsys, tab, subpage
/// output: transaction return code and message.
///          (return code, 1: succeed, -1: failed)
///**********************************************************************
const updateSubjectTitles = r"""
            mutation updateSubjTtitle($subjType: SubjectType!, $subjTitles: [SubjectTitle]!) {
              updateSubjectTitles(subj_type: $subjType, subj_titles: $subjTitles) {
                code
                message
              }
            }

""";

///********************************************************************
/// name: delete_subjects
/// input: list of Ids(one or more) of same subject type, format of
///       {subjecttype, [Id1, Id2,...]}
///       e.g.
///         {
///           "subjType": "subpage",
///            "subjIds": [48,49]
///          }
///         acceptable subject types: parampage, subsys, tab, subpage
/// output: transaction return code and message.
///          (return code, 1: succeed, -1: failed)
///**********************************************************************
const deleteSubjects = r"""
            mutation deleteSubjects($subjType: SubjectType!, $subjIds: [ID]!) {
                deleteSubjects(subj_type: $subjType, subj_Ids: $subjIds) {
                  code
                  message
                }
              }
""";

const removeTree = r"""
            mutation removeTree($treeid: ID!) {
              removeTree(treeid: $treeid)
            }
""";
