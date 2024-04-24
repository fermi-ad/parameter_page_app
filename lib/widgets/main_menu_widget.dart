import 'package:flutter/material.dart';
import 'package:parameter_page/widgets/auth_adapter_widget.dart';

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
              _buildHeader(context),
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

  DrawerHeader _buildHeader(BuildContext context) {
    return DrawerHeader(
        child: Column(children: [_buildBanner(), _buildLoginStatus(context)]));
  }

  Widget _buildBanner() => const Text("Parameter Page Menu");

  Widget _buildLoginStatus(BuildContext context) => _getIsLoggedIn(context)
      ? _buildLoggedInStatus(context)
      : _buildLoggedOutStatus(context);

  bool _getIsLoggedIn(BuildContext context) => _getUsername(context) != null;

  String? _getUsername(BuildContext context) =>
      AuthAdapterData.of(context)!.username;

  Widget _buildLoggedInStatus(BuildContext context) => Column(children: [
        Text("Logged in as ${_getUsername(context)}"),
        TextButton(
          onPressed: () => AuthAdapterState.of(context)!.requestLogout(),
          child: const Text("Logout"),
        )
      ]);

  Widget _buildLoggedOutStatus(BuildContext context) => Column(children: [
        const Text("You are not logged in"),
        TextButton(
            onPressed: () => AuthAdapterState.of(context)!.requestLogin(),
            child: const Text("Login"))
      ]);
}
