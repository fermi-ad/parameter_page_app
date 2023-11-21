/* query to retrieve all parameter page titles
** input: none
** return: list of existing parameter page titles and corresponding pageids
*/
const titlequery = r"""
            query getAllTitles{
              allTitles {
                pageid
                title
                }
            }
          """;


/* query to retrieve the complete tree structure of one parameter page
** input: parameter page id
** return: complete tree structure and values of this parameter page.
*/
const pagequery = r"""
            query getOnePageTree($pageid: ID!) {
              onePageTree(pageid: $pageid) {
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
                                  text
                                  type
                                  seqnum
                              }
                          }
                      }
                  }
              }
            }
          """;
