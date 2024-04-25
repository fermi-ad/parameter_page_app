import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';

abstract class AuthorizationService {
  AuthInfo? get authInfo;

  String? get username;

  Widget buildWidget(Widget child);

  void requestLogout(BuildContext context);

  void requestLogin(BuildContext context);
}
