import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubPageNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final Function()? onIncrement;

  const SubPageNavigationWidget(
      {super.key, this.onIncrement, required this.page});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Container(
            key: const Key("subpagenavigation-subpage-title"),
            child: Text(page.subPageTitle))
      ]),
      const SizedBox(height: 5.0),
      Row(children: [
        Container(
            key: const Key("subpagenavigation-current-subpage"),
            child: Text("${page.subPageIndex}")),
        const SizedBox(width: 5.0),
        const Text("/"),
        const SizedBox(width: 5.0),
        Container(
            key: const Key("subpagenavigation-total-subpages"),
            child: Text("${page.numberOfSubPages}"))
      ])
    ]);
  }
}
