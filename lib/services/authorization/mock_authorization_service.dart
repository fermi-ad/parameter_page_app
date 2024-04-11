import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/services/authorization/authorization_service.dart';

class MockAuthorizationService extends AuthorizationService {
  @override
  AuthInfo? get authInfo => null;
}
