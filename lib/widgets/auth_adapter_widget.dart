import 'package:flutter/material.dart';

class AuthAdapterWidget extends StatefulWidget {
  final Widget child;

  const AuthAdapterWidget({super.key, required this.child});

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
    return Container(child: widget.child);
  }
}
