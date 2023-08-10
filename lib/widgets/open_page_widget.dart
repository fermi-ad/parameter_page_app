import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../parameter_page_service.dart';
import 'open_pages_list_view_widget.dart';
import 'newtitledialog_widget.dart';

class OpenPageWidget extends StatefulWidget {
  final Function(String pageId, String pageTitle) onOpen;

  final ParameterPageService service;

  const OpenPageWidget(
      {super.key, required this.onOpen, required this.service});
  final String title = 'Open Parameter Page';

  @override
  State<OpenPageWidget> createState() => _OpenPageWidgetState();
}

class _OpenPageWidgetState extends State<OpenPageWidget> {
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
          key: const Key("open_page_appbar"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text(
            widget.title,
            style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: OpenPagesListViewWidget(
                titles: titles,
                fetchData: _fetchData,
                service: widget.service,
                onSelected: widget.onOpen),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => {
                      const CircularProgressIndicator(
                        backgroundColor: Colors.amber,
                      ),
                      _fetchData()
                    },
                    child: const Text('<Refresh>',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return NewTitleDialog(
                              titles: titles,
                              fetchData: _fetchData,
                              service: widget.service);
                        },
                      );
                    },
                    child: const Text('<Add page title>',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue)),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  Future<void> _fetchData() async {
    widget.service.fetchPages(onFailure: (String errorMessage) {
      logger.e('fetchPages failure: $errorMessage');
    }, onSuccess: (List<dynamic> newTitles) {
      setState(() {
        titles = newTitles;
      });
    });
  }
}
