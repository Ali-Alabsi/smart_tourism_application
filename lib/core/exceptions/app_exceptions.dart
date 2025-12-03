class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() {
    return 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
  }
}

class NetworkException extends AppException {
  NetworkException(String message, [String? code]) : super(message, code);
}

class AuthenticationException extends AppException {
  AuthenticationException(String message, [String? code]) : super(message, code);
}

class ValidationException extends AppException {
  ValidationException(String message, [String? code]) : super(message, code);
}

class NotFoundException extends AppException {
  NotFoundException(String message, [String? code]) : super(message, code);
}

class ServerException extends AppException {
  ServerException(String message, [String? code]) : super(message, code);
}