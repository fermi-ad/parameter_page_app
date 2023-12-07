///******************************************************* 
/// name: query_allpagetitles
/// input: none
/// output: all the parameter page titles in system
///********************************************************
const query_allpagetitles = r"""
            query getAllPageTitles{
              allPageTitles {
                pageid
                title
                }
            }
          """;



///******************************************************************** 
/// name: query_onepagetree
/// input: pageid (int)
/// output: one complete tree structures and values of one parameter page,
///        including tree title, sub-systems, tabs, sub-pages and entries
///*********************************************************************
const query_onepagetree = r"""
            query getOnePageTree($pageid: ID!) {
              onePageTree(pageid: $pageid) {
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
                      entries:pageentrylist {
                        tabpageid
                        position
                        text
                        type
                      }
                    }
                  }
                }
              }
            }
          """;

