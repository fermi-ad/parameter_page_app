
///******************************************************************** 
/// name: add_defaultpagetree
/// input: parameter page title (string)
/// output: one complete tree structures of single default branche and values
///         of one parameter page, including tree title, one sub-system, 
///         one tab, one sub-page, no user entries.
///**********************************************************************
const add_defaultpagetree = r"""
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
/// name: merge_entries
///      (use to merge(insert, update or mix of both) those new/updated entries,
///      IF transaction deletion is included, run delete_entries first)
/// input: list of entries(one or more) to merge, format of 
///        [
///            {
///              tabpageid, -- same subpage id for all entries in one list
///              position, -- ending position before submit
///              text_old, -- old value at current position, null for new entry
///              text_new, -- new value for current position
///              type_old, -- old value at current position, null for new entry
///              type_new  -- new value for current position
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
const merge_entries =  r"""
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
const delete_entries =  r"""
          mutation deleteEntries($delEntries: [EntryIdInput]!) {
            deletePageEntries(delEntries: $delEntries) {
              code
              message
            }
          }
""";


