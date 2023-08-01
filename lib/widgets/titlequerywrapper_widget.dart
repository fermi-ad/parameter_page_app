import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import '../gqlconnect.dart';
import '../gql_param/mutations.dart';
import 'parampagedetail_widget.dart';

class TitleQueryWrapper extends StatefulWidget {
  final List<dynamic> titles;
  final Function fetchData;

  const TitleQueryWrapper({Key? key, required this.titles, required this.fetchData,}) : super(key: key);

  @override
  State<TitleQueryWrapper> createState() => _TitleQueryWrapperState();
}

class _TitleQueryWrapperState extends State<TitleQueryWrapper> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
                return
                     ListView.builder(
                                itemBuilder: (BuildContext context, int index) {
                                  return  Card(
                                            child: GestureDetector(
                                                    onTap: (){
                                                      Navigator.push(context,
                                                                      MaterialPageRoute(builder: (context) => ParamPageDetail(
                                                                            pageid: widget.titles[index]['pageid'],
                                                                            title: widget.titles[index]['title'],
                                                                           
                                                                        ),
                                                                      ),
                                                                );
                                                      },
                                                    child: SizedBox(
                                                      height:40,
                                                      child: ListTile(
                                                        leading: Text(widget.titles[index]['pageid']),
                                                        title: Text(
                                                          widget.titles[index]['title'], 
                                                          style: const TextStyle(fontSize: 17,),), 
                                                        trailing: IconButton(
                                                                    icon: const Icon(Icons.delete),
                                                                    iconSize: 20,
                                                                    color: Theme.of(context).hintColor,
                                                                    onPressed: ()=>{_deleteTitle(widget.titles[index]['pageid']),
                                                                                    },      
                                                                  ),
                                                    
                                                        selectedColor: Colors.green,
                                                      ),
                                                    ),
                                          ),
                                  );
                                },
                                itemCount: widget.titles.length,
                              );
      }
  

 Future <void> _deleteTitle(String pageid) async {

    final QueryOptions options = QueryOptions(
            document: gql(deletepagetitle),
            variables: <String, dynamic>{
                        'pageid': pageid, 
                      },
        );

      final QueryResult result = await client.value.query(options);
      //final dynamic data = result.data;

      if (result.hasException) {
        logger.e('GraphQL Error: ${result.exception}');
      } 
      else {       
          widget.fetchData();
      } //else
 } //delete Title function


}




