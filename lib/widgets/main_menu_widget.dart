import 'package:flutter/material.dart';

class MainMenuWidget extends StatelessWidget {
  final Function() onNewPage;

  final Function(BuildContext) onOpenPage;

  final bool saveEnabled;

  final Function() onSave;

  final bool copyLinkEnabled;

  final Function() onCopyLink;

  const MainMenuWidget(
      {super.key,
      required this.onNewPage,
      required this.onOpenPage,
      required this.saveEnabled,
      required this.onSave,
      required this.copyLinkEnabled,
      required this.onCopyLink});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        key: const Key("main_menu_icon"),
        child: ListView(
            key: const Key("main_menu"),
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                  child: Column(children: [
                const Text("Parameter Page Menu"),
                Text("Logged in as $_username")
              ])),
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
                  onTap: onSave),
              ListTile(
                  title: const Text("Copy Link"),
                  enabled: copyLinkEnabled,
                  onTap: onCopyLink)
            ]));
  }

  String get _username {
    return "testuser";
  }
}
