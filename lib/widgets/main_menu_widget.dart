import 'package:flutter/material.dart';

class MainMenuWidget extends StatelessWidget {
  final Function() onNewPage;

  final Function(BuildContext) onOpenPage;

  final bool saveEnabled;

  final Function() onSave;

  final bool copyLinkEnabled;

  final String? loggedInAs;

  final Function() onCopyLink;

  final Function()? onLogout;

  const MainMenuWidget(
      {super.key,
      required this.onNewPage,
      required this.onOpenPage,
      required this.saveEnabled,
      required this.onSave,
      required this.copyLinkEnabled,
      required this.loggedInAs,
      required this.onCopyLink,
      required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        key: const Key("main_menu_icon"),
        child: ListView(
            key: const Key("main_menu"),
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(),
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

  DrawerHeader _buildHeader() {
    return DrawerHeader(
        child: Column(children: [
      const Text("Parameter Page Menu"),
      loggedInAs == null
          ? const Text("You are not logged in")
          : Text("Logged in as $loggedInAs"),
      loggedInAs == null
          ? Container()
          : TextButton(
              onPressed: () => onLogout?.call(),
              child: const Text("Logout"),
            )
    ]));
  }
}
