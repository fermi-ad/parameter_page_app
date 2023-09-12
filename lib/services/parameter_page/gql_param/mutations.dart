
const addpagetitle = r"""
        mutation addTitle($title: String!) {
          addTitle(title: $title) {
            pageid
            title
          }
        }
      """;

const updatepagetitle = r"""
        mutation updateTitle($pageid: ID!, $title: String!) {
          updateTitle(pageid: $pageid, title: $title) {
            code,
            message
          }
        }
      """;

const deletepagetitle = r"""
        mutation delTitle($pageid: ID!) {
          deleteTitle(pageid: $pageid) {
            code
            message
          }
        }
      """;


const addpageentry = r"""
      mutation addEntry($pageid: ID!, $position: Int!, $text: String!, $type: EntryType!) {
        addEntry(pageid: $pageid, position: $position, text: $text, type: $type) {
              entryid
              pageid
              position
              text
              type
          }
        }
        """;

const updatepageentry = r"""
      mutation updateEntry($entryid: ID!, $position: Int!, $text: String!, $type: EntryType!) {
        updateEntry(entryid: $entryid, position: $position, text: $text, type: $type) {
          code,
          message
        }
      }
      """;

const deletepageentry = r"""
      mutation deleteEntry($entryid: ID!) {
        deleteEntry(entryid: $entryid) {
          code
          message
        }
      }
      """;

const addentrylist =  r"""
      mutation AddEntryList($newEntryList: [newParamEntry]!) {
        addEntryList(newEntryList: $newEntryList) {
          entryid
        }
      }
""";
/*[newParamEntry] = [{pageid, position, text, type}, ...] */

const updateentrylist =  r"""
      mutation UpdateEntryList($updEntryList: [ParamEntryInput]!) {
        updateEntryList(updEntryList: $updEntryList) {
          code
          message
        }
      }
""";
/*[ParamEntryInput] = [{entryid, position, text, type}, ...] */
 
const deleteentrylist =  r"""
      mutation DeleteEntryList($delEntryList: [EntryIdInput]!) {
        deleteEntryList(delEntryList: $delEntryList) {
          code,
          message
        }
      }
""";
/*[EntryIdInput] = [{entryid}, ...] */

