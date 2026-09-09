import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import 'app_exception.dart';

class DioClient {
  DioClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 15),
              sendTimeout: const Duration(seconds: 15),
              headers: const <String, String>{'Accept': 'application/json'},
            ),
          ) {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: false,
          responseHeader: false,
          responseBody: false,
          logPrint: (Object object) => debugPrint(object.toString()),
        ),
      );
    }
  }

  final Dio _dio;

  Future<T> get<T>(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final Response<T> response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
      );
      final T? data = response.data;
      if (data == null) {
        throw const AppException('Empty response from server.');
      }
      return data;
    } on DioException catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
      }
      throw AppException.fromDio(error);
    }
  }
}
