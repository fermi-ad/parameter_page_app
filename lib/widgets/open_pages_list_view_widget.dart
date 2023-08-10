import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:parameter_page/parameter_page_service.dart';

class OpenPagesListViewWidget extends StatefulWidget {
  final List<dynamic> titles;
  final Function fetchData;
  final ParameterPageService service;
  final Function(String pageId, String pageTitle) onSelected;

  const OpenPagesListViewWidget(
      {Key? key,
      required this.titles,
      required this.fetchData,
      required this.service,
      required this.onSelected})
      : super(key: key);

  @override
  State<OpenPagesListViewWidget> createState() =>
      _OpenPagesListViewWidgetState();
}

class _OpenPagesListViewWidgetState extends State<OpenPagesListViewWidget> {
  final Logger logger = Logger();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const Key("open_page_pages_listview"),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: GestureDetector(
            onTap: () {
              widget.onSelected.call(widget.titles[index]['pageid'],
                  widget.titles[index]['title']);
            },
            child: SizedBox(
              height: 40,
              child: ListTile(
                leading: Text(widget.titles[index]['pageid']),
                title: Text(
                  widget.titles[index]['title'],
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  iconSize: 20,
                  color: Theme.of(context).hintColor,
                  onPressed: () => {
                    _deleteTitle(widget.titles[index]['pageid']),
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

  Future<void> _deleteTitle(String pageid) async {
    widget.service.deletePage(
        withPageId: pageid,
        onFailure: (String errorMessage) {
          logger.e('GraphQL Error: $errorMessage');
        },
        onSuccess: () {
          widget.fetchData();
        });
  } //delete Title function
}
