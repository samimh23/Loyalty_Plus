/// Base class for all custom exceptions.
abstract class AppException implements Exception {
  final String? message;
  final StackTrace? stackTrace;

  AppException([this.message, this.stackTrace]);

  @override
  String toString() {
    final msg = message ?? runtimeType.toString();
    return '[$runtimeType] $msg'
        '${stackTrace != null ? '\nStackTrace: $stackTrace' : ''}';
  }
}

/// Exception for server-related errors.
class ServerException extends AppException {
  ServerException([String? message, StackTrace? stackTrace])
      : super(message, stackTrace);
}

/// Exception for cache/local storage errors.
class CacheException extends AppException {
  CacheException([String? message, StackTrace? stackTrace])
      : super(message, stackTrace);
}

/// Exception for no network connection.
class NoConnectionException extends AppException {
  NoConnectionException([String? message, StackTrace? stackTrace])
      : super(message, stackTrace);
}