import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubSystemNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final bool wide;

  final Function(String selectedSubSystemTitle)? onSelected;

  const SubSystemNavigationWidget(
      {super.key, required this.page, required this.wide, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
        key: const Key("subsystemnavigation"),
        child: DropdownMenu<_SubSystemDirectoryItem>(
          dropdownMenuEntries: _generateMenuEntries(),
        ));
  }

  List<DropdownMenuEntry<_SubSystemDirectoryItem>> _generateMenuEntries() {
    return page.subSystemTitles.map((String subSystemTitle) {
      return DropdownMenuEntry<_SubSystemDirectoryItem>(
          label: subSystemTitle,
          value: _SubSystemDirectoryItem(title: subSystemTitle));
    }).toList();
  }
}

class _SubSystemDirectoryItem {
  final String title;

  const _SubSystemDirectoryItem({required this.title});
}
