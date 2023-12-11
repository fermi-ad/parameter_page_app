import 'package:flutter/material.dart';
import 'package:parameter_page/entities/parameter_page.dart';

class SubSystemNavigationWidget extends StatelessWidget {
  final ParameterPage page;

  final bool wide;

  final Function(String selectedSubSystemTitle)? onSelected;

  final Function()? onNewSubSystem;

  final Function(String)? onTitleChanged;

  final Function()? onDelete;

  const SubSystemNavigationWidget(
      {super.key,
      required this.page,
      required this.wide,
      this.onSelected,
      this.onNewSubSystem,
      this.onTitleChanged,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(key: const Key("subsystemnavigation"), children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
          child: _buildDropdownMenu()),
      Visibility(visible: page.editing, child: _buildEditModeToolbar(context))
    ]);
  }

  Widget _buildEditModeToolbar(BuildContext context) {
    return Row(children: [
      IconButton(
          icon: const Icon(Icons.add), onPressed: () => onNewSubSystem?.call()),
      IconButton(
          icon: const Icon(Icons.delete), onPressed: () => onDelete?.call()),
      IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _handleTitleChange(context))
    ]);
  }

  DropdownMenu<String> _buildDropdownMenu() {
    return DropdownMenu<String>(
        key: const Key("subsystemnavigation-menu"),
        width: wide ? 300 : null,
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

  void _handleTitleChange(BuildContext context) {
    final controller = TextEditingController(text: page.subSystemTitle);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            key: const Key("rename-subsystem-dialog"),
            title: const Text('Rename Sub-system'),
            content: TextField(controller: controller),
            actions: <Widget>[
              MaterialButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child: const Text('OK'),
                onPressed: () {
                  onTitleChanged?.call(controller.text);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
