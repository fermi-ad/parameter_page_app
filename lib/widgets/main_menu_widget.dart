import 'package:flutter/material.dart';

class MainMenuWidget extends StatelessWidget {
  final Function() onNewPage;

  final Function(BuildContext) onOpenPage;

  final bool saveEnabled;

  final Function() onSave;

  const MainMenuWidget(
      {super.key,
      required this.onNewPage,
      required this.onOpenPage,
      required this.saveEnabled,
      required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        key: const Key("main_menu_icon"),
        child: ListView(
            key: const Key("main_menu"),
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text("Parameter Page Menu")),
              ListTile(title: const Text("New Page"), onTap: onNewPage),
              ListTile(
                  title: const Text("Open Page"),
                  onTap: () {
                    Navigator.pop(context);
                    onOpenPage.call(context);
                  }),
              ListTile(
                  title: const Text("Save"),
                  enabled: saveEnabled,
                  onTap: onSave)
            ]));
  }
}
