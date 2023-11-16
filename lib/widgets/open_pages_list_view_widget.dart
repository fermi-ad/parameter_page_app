import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';

class OpenPagesListViewWidget extends StatefulWidget {
  final List<dynamic> titles;
  final Function fetchData;
  final ParameterPageService service;
  final Function(String pageId, String pageTitle) onSelected;

  const OpenPagesListViewWidget(
      {super.key,
      required this.titles,
      required this.fetchData,
      required this.service,
      required this.onSelected});

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
            child: ListTile(
              leading: Text(widget.titles[index]['pageid']),
              title: Text(
                widget.titles[index]['title'],
              ),
              selectedColor: Colors.green,
            ),
          ),
        );
      },
      itemCount: widget.titles.length,
    );
  } //delete Title function
}
