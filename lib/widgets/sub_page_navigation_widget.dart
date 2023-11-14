import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubPageNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  const SubPageNavigationWidget({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: const Key("subpagenavigation-current-subpage"),
        child: Text("${page.subPageIndex}"));
  }
}
