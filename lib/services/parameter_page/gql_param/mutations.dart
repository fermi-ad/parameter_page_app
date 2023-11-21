
/* mutation to create default tree structure of new parametr page
** input: page title
** return: default tree struture of a new parameter page without page entry
*/
const newParamPageDefTree = r"""
        mutation newParamPage($title: String!) {
                newParamPage(title: $title) {
                  pageid
                  title
                  subsyslist {
                      subsysid
                      title
                      seqnum
                      subsystablist {
                          subsystabid
                          title
                          seqnum
                          tabpagelist {
                              tabpageid
                              seqnum
                              pageentrylist {
                                  entryid
                              }
                          }
                      }
                  }
              }
        }
      """;

/* mutation to update parameter page title
** input: parameter page id, page title to update
** return: status code and message of transaction execution
*/
const updatepagetitle = r"""
        mutation updateTitle($pageid: ID!, $title: String!) {
          updateTitle(pageid: $pageid, title: $title) {
            code,
            message
          }
        }
      """;

/* mutation to delete parameter page title, it should have no associated subsys
** input: parameter page id
** return: status code and message of transaction execution
*/
const deletepagetitle = r"""
        mutation delTitle($pageid: ID!) {
          deleteTitle(pageid: $pageid) {
            code
            message
          }
        }
      """;

/*[EntryIdInput] = [{entryid}, ...] */

