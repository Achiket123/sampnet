part of 'auth_bloc.dart';

sealed class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final SignUpParams signUpParams;
  SignUpEvent({required this.signUpParams});
}

class SignInEvent extends AuthEvent {
  final SignInParams signInParams;
  SignInEvent({required this.signInParams});
}

class SignOutEvent extends AuthEvent{}

class GetTokenEvent extends AuthEvent{}