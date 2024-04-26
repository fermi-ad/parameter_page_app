import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/services/authorization/authorization_service.dart';

class MockAuthorizationService extends AuthorizationService {
  @override
  AuthInfo? get authInfo => null;

  @override
  Widget buildWidget(Widget child) => Container(child: child);

  @override
  void requestLogout(BuildContext context) {
    _username = null;
  }

  @override
  Future<void> requestLogin(BuildContext context) async {
    _username = "testuser";
  }

  String? _username = "testuser";

  @override
  String? getUsername(BuildContext context) {
    return _username;
  }
}
