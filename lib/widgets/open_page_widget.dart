import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import '../gqlconnect.dart';
import '../gql_param/queries.dart';
import 'titlequerywrapper_widget.dart';
import 'newtitledialog_widget.dart';

class OpenPageWidget extends StatefulWidget {
  final Function() onOpen;

  const OpenPageWidget({super.key, required this.onOpen});
  final String title = 'Parameter Page Titles';

  @override
  State<OpenPageWidget> createState() => _OpenPageWidgetState();
}
 
class _OpenPageWidgetState extends State<OpenPageWidget>{
  List<dynamic> titles = [];
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchData(); // Fetch initial data when the widget is initialized
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text(
              widget.title, 
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontStyle:FontStyle.normal),
              ),  
        ),
      ),
      body: 
          Column(
            children: [
              Expanded(
                child: TitleQueryWrapper(
                          titles: titles,
                          fetchData: _fetchData,
                        ),
              ),
              Container(
                      padding:const EdgeInsets.all(10), 
                      child: 
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector (
                              onTap: ()=> {const CircularProgressIndicator(backgroundColor: Colors.amber,),
                              _fetchData()},
                              child: const Text('<Refresh>', style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
                            ),
                            GestureDetector (
                              onTap: () async {
                                await showDialog(
                                  context: context, 
                                  builder: (BuildContext dialogContext){
                                    return NewTitleDialog(titles:titles, fetchData:_fetchData);
                                  },
                                );
                              },
                              child: const Text('<Add page title>', style:TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue)),
                            ),
                          ],
                        )
                      ),
            ],
          ),
    );
  }


  Future <void> _fetchData() async {
    final QueryOptions options = QueryOptions(
            document: gql(titlequery),
            fetchPolicy: FetchPolicy.noCache,
        );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
          logger.e('GraphQL Error: ${result.exception}');
          } 
    else {
        setState(() {
          titles = [];
          titles = result.data? ['allTitles'];
        });  
    }
  } //fetchData function


}