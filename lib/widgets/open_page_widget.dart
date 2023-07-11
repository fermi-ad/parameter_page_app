import 'package:flutter/material.dart';

class OpenPageWidget extends StatelessWidget {
  final Function() onOpen;

  const OpenPageWidget({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          key: const Key("open_page_appbar"),
          title: const Text('Open Parameter Page'),
        ),
        body: const Text("TODO: OpenPageWidget"));
  }
}
