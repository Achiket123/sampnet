part of 'auth_bloc.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}


final class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});
}

final class AuthSignUpSuccess extends AuthState {
  final UserEntity user;
  AuthSignUpSuccess({required this.user});
}


final class AuthSignInSuccess extends AuthState {
  final UserEntity user;
  AuthSignInSuccess({required this.user});
}

final class AuthSignOutSuccess extends AuthState {
  final String message;
  AuthSignOutSuccess({required this.message});
}


final class AuthGetTokenSuccess extends AuthState {
  final String token;
  AuthGetTokenSuccess({required this.token});
}
