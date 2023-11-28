import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubSystemNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final bool wide;

  const SubSystemNavigationWidget(
      {super.key, required this.page, required this.wide});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: const Key("subsystemnavigation"),
        child: Text(page.subSystemTitle));
  }
}
