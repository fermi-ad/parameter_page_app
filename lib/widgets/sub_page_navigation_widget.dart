import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubPageNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final Function()? onForward;

  final Function()? onBackward;

  const SubPageNavigationWidget(
      {super.key, this.onForward, this.onBackward, required this.page});

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
        IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () => onBackward?.call()),
        const SizedBox(width: 5.0),
        Container(
            key: const Key("subpagenavigation-current-subpage"),
            child: Text("${page.subPageIndex}")),
        const SizedBox(width: 5.0),
        const Text("/"),
        const SizedBox(width: 5.0),
        Container(
            key: const Key("subpagenavigation-total-subpages"),
            child: Text("${page.numberOfSubPages}")),
        const SizedBox(width: 5.0),
        IconButton(
          icon: const Icon(Icons.navigate_next, size: 16.0),
          onPressed: () => onForward?.call(),
        )
      ])
    ]);
  }
}
