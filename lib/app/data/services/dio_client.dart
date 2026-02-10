import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import '../../core/errors/failures.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    // Add Retry Interceptor
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        logPrint: (message) => debugPrint(message),
        retries: 3, // retry count
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    // Add Logging Interceptor in Debug Mode
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure(
            message: 'Error de conexión por tiempo de espera');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return NetworkFailure(
          message: 'Error del servidor: $statusCode',
          code: statusCode?.toString(),
        );
      case DioExceptionType.cancel:
        return const NetworkFailure(message: 'Petición cancelada');
      case DioExceptionType.connectionError:
        return const NetworkFailure(message: 'Sin conexión a internet');
      default:
        return NetworkFailure(message: 'Error inesperado: ${error.message}');
    }
  }
}
