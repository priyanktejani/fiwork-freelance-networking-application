import 'package:fiwork/services/auth/auth_user.dart';

// 2
abstract class AuthProvider {
  Future<void> initialize();
  
  // it will return current user (google, facebook or any other method)
  AuthUser? get currentUser;

  // log in
  // retuen AuthUser optional if firebase login fail
  Future<AuthUser?> logIn({
    required email,
    required password,
  });

  // sign up
  Future<AuthUser?> createUser({
    required email,
    required password,
  });

  Future<void> logout();

  Future<void> sendEmailVerification();
}
