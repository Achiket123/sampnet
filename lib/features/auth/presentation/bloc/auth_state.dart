part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

final class AuthSignUpSuccess extends AuthState {
  final AuthResponseEntity auth;
  AuthSignUpSuccess({required this.auth});
}

final class AuthSignInSuccess extends AuthState {
  final AuthResponseEntity auth;
  AuthSignInSuccess({required this.auth});
}

final class AuthSignOutSuccess extends AuthState {
  final String message;
  AuthSignOutSuccess({required this.message});
}

final class AuthGetTokenSuccess extends AuthState {
  final String token;
  AuthGetTokenSuccess({required this.token});
}
