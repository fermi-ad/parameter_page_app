import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/services/authorization/authorization_service.dart';

class MockAuthorizationService extends AuthorizationService {
  @override
  AuthInfo? get authInfo => null;

  @override
  String? get username => _username;

  @override
  Widget buildWidget(Widget child) => Container(child: child);

  @override
  void requestLogout() {
    _username = null;
  }

  @override
  void requestLogin() {
    _username = "testuser";
  }

  String? _username = "testuser";
}
