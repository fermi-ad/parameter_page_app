import 'package:flutter/material.dart';
import 'package:parameter_page/services/authorization/authorization_service.dart';

class AuthAdapterWidget extends StatefulWidget {
  final Widget child;

  final AuthorizationService service;

  const AuthAdapterWidget(
      {super.key, required this.child, required this.service});

  String? get username {
    return "testuser";
  }

  @override
  State<AuthAdapterWidget> createState() {
    return _AuthAdapterState();
  }

  static AuthAdapterWidget? of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<AuthAdapterWidget>();
}

class _AuthAdapterState extends State<AuthAdapterWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.service.buildWidget(widget.child);
  }
}
