import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubPageNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final Function()? onForward;

  final Function()? onBackward;

  final Function(int)? onSelected;

  final Function()? onNewSubPage;

  const SubPageNavigationWidget(
      {super.key,
      this.onForward,
      this.onBackward,
      this.onSelected,
      this.onNewSubPage,
      required this.page});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _buildBackwardsButton(),
      const SizedBox(width: 5.0),
      _buildCurrentSubPageIndex(),
      const SizedBox(width: 5.0),
      const Text("/"),
      const SizedBox(width: 5.0),
      _buildTotalNumberOfSubPages(),
      const SizedBox(width: 5.0),
      _buildForwardsButton(),
      const SizedBox(width: 15.0),
      _buildSubPageTitle(),
      const SizedBox(width: 5.0),
      Visibility(
          visible: page.numberOfSubPages > 1,
          child: _buildDirectoryMenuButton()),
      _buildNewSubPageButton()
    ]);
  }

  Widget _buildNewSubPageButton() {
    return FilledButton(
        onPressed: () => onNewSubPage?.call(),
        child: const Text("New Sub-Page"));
  }

  Widget _buildCurrentSubPageIndex() {
    return SizedBox(
        width: 48.0,
        child: TextFormField(
          key: const Key('subpagenavigation-current-index-input'),
          controller: TextEditingController(text: "${page.subPageIndex}"),
          onFieldSubmitted: _handleDirectNavigation,
        ));
  }

  Widget _buildTotalNumberOfSubPages() {
    return Container(
        key: const Key("subpagenavigation-total-subpages"),
        child: Text("${page.numberOfSubPages}"));
  }

  Widget _buildBackwardsButton() {
    return IconButton(
        icon: const Icon(Icons.navigate_before),
        onPressed: () => onBackward?.call());
  }

  Widget _buildForwardsButton() {
    return IconButton(
      icon: const Icon(Icons.navigate_next),
      onPressed: () => onForward?.call(),
    );
  }

  Widget _buildSubPageTitle() {
    return Container(
        key: const Key("subpagenavigation-subpage-title"),
        child: Text(page.subPageTitle));
  }

  Widget _buildDirectoryMenuButton() {
    return PopupMenuButton<_SubPageDirectoryItem>(
        icon: const Icon(Icons.expand_more),
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
          child: Row(children: [
            SizedBox(width: 30, child: Text("${i + 1}:")),
            Text(page.subPageDirectory[i])
          ])));
    }
    return ret;
  }

  void _handleDirectNavigation(String indexInput) {
    final int? index = int.tryParse(indexInput);
    if (index != null && index > 0 && index <= page.subPageDirectory.length) {
      onSelected?.call(index);
    }
  }
}

class _SubPageDirectoryItem {
  final String title;

  final int index;

  const _SubPageDirectoryItem({required this.index, required this.title});
}
