const titlequery = r"""
            query getAllTitles{
              allTitles {
                pageid
                title
                }
            }
          """;

const pageentryquery = r"""
            query findtitleentry ($pageid: ID) {
              entriesInPageX(pageid: $pageid) {
                entryid
                pageid
                position
                text
                type
              }
            }
          """;


