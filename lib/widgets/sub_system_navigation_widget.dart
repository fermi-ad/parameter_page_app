import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubSystemNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final bool wide;

  final Function(String selectedSubSystemTitle)? onSelected;

  final Function()? onNewSubSystem;

  const SubSystemNavigationWidget(
      {super.key,
      required this.page,
      required this.wide,
      this.onSelected,
      this.onNewSubSystem});

  @override
  Widget build(BuildContext context) {
    return Row(key: const Key("subsystemnavigation"), children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: _buildDropdownMenu()),
      Visibility(visible: page.editing, child: _buildEditModeToolbar())
    ]);
  }

  Widget _buildEditModeToolbar() {
    return Row(children: [
      IconButton(icon: const Icon(Icons.add), onPressed: () {}),
      IconButton(icon: const Icon(Icons.delete), onPressed: () {}),
      IconButton(icon: const Icon(Icons.edit), onPressed: () {})
    ]);
  }

  DropdownMenu<String> _buildDropdownMenu() {
    return DropdownMenu<String>(
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
        ),
        textStyle: const TextStyle(fontSize: 18.0),
        initialSelection: page.subSystemTitle,
        dropdownMenuEntries: _generateMenuEntries(),
        onSelected: _handleSelected);
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
