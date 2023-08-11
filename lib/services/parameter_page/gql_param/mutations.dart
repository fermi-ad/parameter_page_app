const deletepageentry = r"""
        mutation delEntry($entryid: ID!) {
          deleteEntry(entryid: $entryid) {
            code
            message
          }
        }
      """;

const addpagetitle = r"""
        mutation addTitle($title: String!) {
          addTitle(title: $title) {
            pageid
            title
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