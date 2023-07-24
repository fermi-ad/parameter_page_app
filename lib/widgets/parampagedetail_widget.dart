import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import '../gqlconnect.dart';
import '../gql_param/queries.dart';
import 'entryquerywrapper_widget.dart';


class ParamPageDetail extends StatefulWidget {
  final String pageid;
  final String title;

 const  ParamPageDetail({super.key, required this.pageid, required this.title});

  @override
  State<ParamPageDetail> createState() => _ParamPageDetailState();
}

class _ParamPageDetailState extends State<ParamPageDetail> {

  List<dynamic> entries = [];
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchEntryData(); // Fetch initial data when the widget is initialized
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
              'Parameter Page Details -- ${widget.title}', 
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, fontStyle: FontStyle.normal),
              ), 
        ),
      ),
      body: 
           Column(
                  children: [
                    Expanded(
                      child: EntryQueryWrapper(
                                entries: entries,
                                fetchData: _fetchEntryData,
                              ),
                    ),
                    Container(
                      padding:const EdgeInsets.all(10), 
                      child: GestureDetector (
                        onTap: () {_showEditDialog(context);},
                        child: const Text('<Add entry>', style:TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue))
                        )
                      ),
                  ]
          )
      );
  }

final TextEditingController _textEditingController = TextEditingController();

// Function to show the edit dialog
void _showEditDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Enter new entry'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                hintText: 'Enter value',
              ),
            ),

            const SizedBox(height: 16),

          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(dialogContext); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              //String editedText = _textEditingController.text.trim();
              // Perform save operation with editedText
              Navigator.pop(dialogContext); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}

 Future <void> _fetchEntryData() async {
    final QueryOptions options = QueryOptions(
            document: gql(pageentryquery),
            variables: <String, dynamic>{'pageid': widget.pageid},
            fetchPolicy: FetchPolicy.noCache,
        );

    final QueryResult result = await client.value.query(options);

    if (result.hasException) {
          logger.e('GraphQL Error: ${result.exception}');
          } 
    else {
        setState(() {
          entries = [];
          entries = result.data? ['entriesInPageX']??[];
        });  
    }
  } //fetchData function
    
}