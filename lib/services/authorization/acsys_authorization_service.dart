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
  Widget buildWidget(Widget child) => Container(child: child);

  @override
  void requestLogout(BuildContext context) {
    AuthService.requestLogout(context);
  }

  @override
  void requestLogin(BuildContext context) {
    AuthService.requestLogin(context);
  }

  @override
  String? getUsername(BuildContext context) {
    final creds = AuthService.getCreds(context)?.idToken.claims;
    return creds?.preferredUsername;
  }
}
