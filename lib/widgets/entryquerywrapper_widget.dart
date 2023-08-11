import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:logger/logger.dart';
import '../gqlconnect.dart';
import '../services/parameter_page/gql_param/mutations.dart';

class EntryQueryWrapper extends StatefulWidget {
  final List<dynamic> entries;
  final Function fetchData;

  const EntryQueryWrapper({
    Key? key,
    required this.entries,
    required this.fetchData,
  }) : super(key: key);

  @override
  State<EntryQueryWrapper> createState() => _EntryQueryWrapperState();
}

class _EntryQueryWrapperState extends State<EntryQueryWrapper> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: GestureDetector(
            onTap: () {},
            child: ListTile(
              title: Text(
                widget.entries[index]['text'],
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              subtitle: Text(
                widget.entries[index]['type'],
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                iconSize: 20,
                color: Theme.of(context).hintColor,
                onPressed: () => {
                  _deleteEntry(widget.entries[index]['entryid']),
                },
              ),
              selectedColor: Colors.green,
            ),
          ),
        );
      },
      itemCount: widget.entries.length,
    );
  }

  Future<void> _deleteEntry(String entryid) async {
    final QueryOptions options = QueryOptions(
      document: gql(deletepageentry),
      variables: <String, dynamic>{
        'entryid': entryid,
      },
    );

    final QueryResult result = await client.value.query(options);
    //final dynamic data = result.data;

    if (result.hasException) {
      logger.e('GraphQL Error: ${result.exception}');
    } else {
      widget.fetchData();
    } //else
  } //delete Title function
}
