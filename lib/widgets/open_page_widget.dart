import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/fermi_controls_common/error_display_widget.dart';
import '../services/parameter_page/parameter_page_service.dart';
import 'open_pages_list_view_widget.dart';

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
  bool get isLoading {
    return _titles == null;
  }

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
          title: Text(widget.title),
        ),
      ),
      body: _errorMessage != null
          ? _buildError(_errorMessage!)
          : isLoading
              ? _buildLoading()
              : _buildPageList(_titles!),
    );
  }

  Widget _buildError(String detailMessage) {
    return ErrorDisplayWidget(
        key: const Key("open_pages_list_error"),
        errorMessage:
            "The request for parameter page titles failed, please try again.",
        detailMessage: detailMessage);
  }

  Widget _buildLoading() {
    return const Row(children: [
      Spacer(),
      Column(children: [
        Spacer(),
        CircularProgressIndicator(),
        SizedBox(height: 16),
        Text("Loading..."),
        Spacer()
      ]),
      Spacer()
    ]);
  }

  Widget _buildPageList(List<dynamic> titles) {
    return Column(
      children: [
        Expanded(
          child: OpenPagesListViewWidget(
              titles: titles,
              fetchData: _fetchData,
              service: widget.service,
              onSelected: (String pageId, String pageTitle) =>
                  _handlePageSelected(context, pageId, pageTitle)),
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
              ],
            )),
      ],
    );
  }

  void _handlePageSelected(
      BuildContext context, String pageId, String pageTitle) {
    widget.onOpen(pageId, pageTitle);
  }

  Future<void> _fetchData() async {
    setState(() {
      _titles = null;
      _errorMessage = null;
    });

    await widget.service.fetchPages().then((List<dynamic> newTitles) {
      setState(() {
        _titles = newTitles;
        _errorMessage = null;
      });
    }).catchError((error) {
      setState(() {
        _errorMessage = error.toString();
      });
    });
  }

  List<dynamic>? _titles;

  String? _errorMessage;
}
