class ErrorModel implements Exception {
  final String message;
  ErrorModel({required this.message});
}

class ServerError extends ErrorModel {
  ServerError({required super.message});
}

class NetworkError extends ErrorModel {
  NetworkError({required super.message});
}

class AuthError extends ErrorModel {
  AuthError({required super.message});
}

class ValidationError extends ErrorModel {
  ValidationError({required super.message});
}
