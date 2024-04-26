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
  }

  @override
  Widget build(BuildContext context) {
    _username = widget.service.getUsername(context);
    return AuthAdapterData(
        username: _username, child: widget.service.buildWidget(widget.child));
  }

  static AuthAdapterState? of(BuildContext context) =>
      context.findAncestorStateOfType<AuthAdapterState>();

  void requestLogout(BuildContext context) {
    widget.service.requestLogout(context);
    setState(() => _username = null);
  }

  Future<void> requestLogin(BuildContext context) async {
    widget.service.requestLogin(context);
    setState(() {
      _username = widget.service.getUsername(context);
    });
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
