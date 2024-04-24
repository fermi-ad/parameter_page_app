import 'package:flutter/material.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:parameter_page/services/authorization/authorization_service.dart';

class ACSysAuthorizationService extends AuthorizationService {
  @override
  AuthInfo? get authInfo {
    return AuthInfo(
        realm: dotenv.env['AUTH_INFO_REALM']!,
        scopes: [],
        clientId: dotenv.env['AUTH_INFO_CLIENT_ID']!,
        clientSecret: dotenv.env['AUTH_INFO_CLIENT_SECRET']!);
  }

  @override
  String? get username {
    return "unimplemented!";
  }

  @override
  Widget buildWidget(Widget child) => Container(child: child);

  @override
  void requestLogout() {
    throw UnimplementedError("ACSysAuthorizationService.requestLogout()");
  }

  @override
  void requestLogin() {
    throw UnimplementedError("ACSysAuthorizationService.requestLogin()");
  }
}
