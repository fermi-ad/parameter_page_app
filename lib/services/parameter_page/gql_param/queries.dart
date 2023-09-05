const titlequery = r"""
            query getAllTitles{
              allTitles {
                pageid
                title
                }
            }
          """;

const pageentryquery = r"""
            query findtitleentry ($pageid: ID!) {
              entriesInPageX(pageid: $pageid) {
                entryid
                pageid
                position
                text
                type
              }
            }
          """;

const pagequery = r"""
            query getOnePage($pageid: ID!) {
              onePage(pageid: $pageid) {
                pageid
                title
                entries {
                        entryid
                        position
                        text
                        type
                      }
                }
            }
          """;
