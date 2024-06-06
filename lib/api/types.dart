import 'package:dmtransport/models/user.model.dart';

class LoginResponse {
  final User user;
  final String loginToken;

  LoginResponse(this.user, this.loginToken);
}
