import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubPageNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final bool wide;

  final Function()? onForward;

  final Function()? onBackward;

  final Function(int)? onSelected;

  final Function()? onNewSubPage;

  final Function()? onDeleteSubPage;

  final Function(String)? onTitleChanged;

  SubPageNavigationWidget(
      {super.key,
      this.onForward,
      this.onBackward,
      this.onSelected,
      this.onNewSubPage,
      this.onDeleteSubPage,
      this.onTitleChanged,
      required this.wide,
      required this.page})
      : _titleTextController = TextEditingController(text: page.subPageTitle);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _buildBackwardsButton(),
      _buildCurrentSubPageIndex(),
      const Text(" / "),
      _buildTotalNumberOfSubPages(),
      _buildForwardsButton(),
      const SizedBox(width: 10.0),
      _buildDropDownMenu(),
      Visibility(visible: page.editing, child: _buildNewSubPageButton()),
      const SizedBox(width: 5.0),
      Visibility(visible: page.editing, child: _buildDeleteSubPageButton())
    ]);
  }

  Widget _buildDeleteSubPageButton() {
    return Flexible(
        child: wide
            ? TextButton.icon(
                key: const Key("subpagenavigation-deletesubpage"),
                onPressed: _isDeleteButtonEnabled
                    ? () => onDeleteSubPage?.call()
                    : null,
                icon: const Icon(Icons.delete),
                label: const Text("Delete Sub-Page"))
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _isDeleteButtonEnabled
                    ? () => onDeleteSubPage?.call()
                    : null));
  }

  Widget _buildNewSubPageButton() {
    return Flexible(
        child: wide
            ? TextButton.icon(
                onPressed: () => onNewSubPage?.call(),
                icon: const Icon(Icons.add),
                label: const Text("New Sub-Page"))
            : IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => onNewSubPage?.call()));
  }

  Widget _buildCurrentSubPageIndex() {
    return SizedBox(
        width: 36.0,
        child: TextFormField(
          key: const Key('subpagenavigation-current-index-input'),
          style: const TextStyle(fontSize: 18.0),
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isCollapsed: true,
              contentPadding: EdgeInsets.fromLTRB(0, 5, 5, 5)),
          controller: TextEditingController(text: "${page.subPageIndex}"),
          onFieldSubmitted: _handleDirectNavigation,
          textAlign: TextAlign.right,
        ));
  }

  Widget _buildTotalNumberOfSubPages() {
    return Container(
        key: const Key("subpagenavigation-total-subpages"),
        child: Text("${page.numberOfSubPages}"));
  }

  Widget _buildBackwardsButton() {
    return IconButton(
        icon: const Icon(Icons.navigate_before, size: 24.0),
        onPressed: () => onBackward?.call());
  }

  Widget _buildForwardsButton() {
    return IconButton(
      icon: const Icon(Icons.navigate_next, size: 24.0),
      onPressed: () => onForward?.call(),
    );
  }

  Widget _buildDropDownMenu() {
    return Row(children: [
      Container(
          key: const Key("subpagenavigation-subpage-title"),
          child: page.editing
              ? _buildSubPageTitleTextField()
              : _buildSubPageTitleDisplay()),
      const SizedBox(width: 5.0),
      Visibility(
          visible: page.numberOfSubPages > 1,
          child: _buildDirectoryMenuButton())
    ]);
  }

  Widget _buildSubPageTitleDisplay() {
    return Text(page.subPageTitle);
  }

  Widget _buildSubPageTitleTextField() {
    return Expanded(
        flex: 3,
        child: TextField(
          controller: _titleTextController,
          onTapOutside: (event) =>
              onTitleChanged?.call(_titleTextController.text),
          onEditingComplete: () =>
              onTitleChanged?.call(_titleTextController.text),
        ));
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

  bool get _isDeleteButtonEnabled {
    return page.numberOfSubPages > 1;
  }

  final TextEditingController _titleTextController;
}

class _SubPageDirectoryItem {
  final String title;

  final int index;

  const _SubPageDirectoryItem({required this.index, required this.title});
}
