import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';

abstract class AuthorizationService {
  AuthInfo? get authInfo;

  Widget buildWidget(Widget child);

  String? getUsername(BuildContext context);

  void requestLogout(BuildContext context);

  void requestLogin(BuildContext context);
}
