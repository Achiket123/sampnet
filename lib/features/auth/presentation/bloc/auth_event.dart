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

class SendVerificationEmailEvent extends AuthEvent {}

class VerifyEmailEvent extends AuthEvent {
  final String token;
  VerifyEmailEvent({required this.token});
}

class GetMeEvent extends AuthEvent {}