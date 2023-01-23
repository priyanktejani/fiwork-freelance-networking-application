import 'package:fiwork/services/auth/auth_user.dart';

// 2
abstract class AuthProvider {
  Future<void> initialize();

  AuthUser? get currentUser;

  Future<AuthUser?> logIn({
    required email,
    required password,
  });

  Future<AuthUser?> createUser({
    required email,
    required password,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();
}
