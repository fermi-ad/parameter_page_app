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
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: DropdownMenu<String>(
                inputDecorationTheme: const InputDecorationTheme(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                    border: OutlineInputBorder()),
                textStyle: const TextStyle(fontSize: 18.0),
                initialSelection: page.subSystemTitle,
                dropdownMenuEntries: _generateMenuEntries(),
                onSelected: _handleSelected)));
  }

  List<DropdownMenuEntry<String>> _generateMenuEntries() {
    return page.subSystemTitles.map((String subSystemTitle) {
      return DropdownMenuEntry<String>(
          label: subSystemTitle, value: subSystemTitle);
    }).toList();
  }

  void _handleSelected(String? selected) {
    if (selected != null) {
      onSelected?.call(selected);
    }
  }
}
