import 'package:dio/dio.dart';

class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory AppException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException(
          'This is taking too long. Check your connection and try again.',
        );
      case DioExceptionType.connectionError:
        return const AppException(
          'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        final int? code = error.response?.statusCode;
        if (code == 404) {
          return const AppException(
            'We could not find what you were looking for.',
            statusCode: 404,
          );
        }
        if (code != null && code >= 500) {
          return AppException(
            'The store is unavailable right now. Please try again.',
            statusCode: code,
          );
        }
        return AppException(
          'Something went wrong. Please try again.',
          statusCode: code,
        );
      case DioExceptionType.cancel:
        return const AppException('Request was cancelled.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      case DioExceptionType.transformTimeout:
        return const AppException('Something went wrong. Please try again.');
    }
  }

  @override
  String toString() => 'AppException($statusCode): $message';
}
