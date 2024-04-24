import 'package:flutter/material.dart';
import 'package:parameter_page/services/authorization/authorization_service.dart';

class AuthAdapterWidget extends StatefulWidget {
  final Widget child;

  final AuthorizationService service;

  const AuthAdapterWidget(
      {super.key, required this.child, required this.service});

  @override
  State<StatefulWidget> createState() {
    return AuthAdapterState();
  }
}

class AuthAdapterState extends State<AuthAdapterWidget> {
  @override
  initState() {
    super.initState();
    _username = widget.service.username;
  }

  @override
  Widget build(BuildContext context) {
    return AuthAdapterData(
        username: _username, child: widget.service.buildWidget(widget.child));
  }

  static AuthAdapterState? of(BuildContext context) =>
      context.findAncestorStateOfType<AuthAdapterState>();

  void requestLogout() {
    widget.service.requestLogout();
    setState(() => _username = null);
  }

  void requestLogin() {
    widget.service.requestLogin();
    setState(() => _username = widget.service.username);
  }

  String? _username;
}

class AuthAdapterData extends InheritedWidget {
  final String? username;

  const AuthAdapterData(
      {super.key, required super.child, required this.username});

  static AuthAdapterData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthAdapterData>();
  }

  @override
  bool updateShouldNotify(AuthAdapterData oldWidget) {
    return oldWidget.username != username;
  }
}
