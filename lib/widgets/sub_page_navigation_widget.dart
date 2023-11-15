import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubPageNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final Function()? onForward;

  final Function()? onBackward;

  final Function(int)? onSelected;

  const SubPageNavigationWidget(
      {super.key,
      this.onForward,
      this.onBackward,
      this.onSelected,
      required this.page});

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
        SizedBox(
            width: 48.0,
            child: TextFormField(
              key: const Key('subpagenavigation-current-index-input'),
              controller: TextEditingController(text: "${page.subPageIndex}"),
              onFieldSubmitted: (String input) =>
                  onSelected?.call(int.parse(input)),
            )),
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
      ]),
      Row(children: [_buildDirectoryMenuButton()])
    ]);
  }

  Widget _buildDirectoryMenuButton() {
    return PopupMenuButton<_SubPageDirectoryItem>(
        icon: const Icon(Icons.more_vert),
        onSelected: (_SubPageDirectoryItem selected) =>
            onSelected?.call(selected.index),
        itemBuilder: _directoryItemBuilder);
  }

  List<PopupMenuItem<_SubPageDirectoryItem>> _directoryItemBuilder(
      BuildContext context) {
    List<PopupMenuItem<_SubPageDirectoryItem>> ret = [];
    for (int i = 0; i != page.subPageDirectory.length; i++) {
      ret.add(PopupMenuItem<_SubPageDirectoryItem>(
          value: _SubPageDirectoryItem(
              index: i + 1, title: page.subPageDirectory[i]),
          child: Text(page.subPageDirectory[i])));
    }
    return ret;
  }
}

class _SubPageDirectoryItem {
  final String title;

  final int index;

  const _SubPageDirectoryItem({required this.index, required this.title});
}
