import 'package:dio/dio.dart';
import 'package:smart_tourism_application/data/datasources/local/shared_prefs.dart';

class DioClient {
  final Dio _dio;
  final String baseUrl;

  DioClient({required this.baseUrl}) : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add logging interceptor
    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      logPrint: (obj) => print(obj),
    ));
    
    // Add token interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Get token from shared preferences
        final sharedPrefs = SharedPrefs();
        final token = await sharedPrefs.getString('authToken');
        
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        print('REQUEST HEADERS: ${options.headers}');
        print('REQUEST DATA: ${options.data}');
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        print('RESPONSE DATA: ${response.data}');
        
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        print('ERROR MESSAGE: ${e.message}');
        print('ERROR RESPONSE: ${e.response?.data}');
        
        return handler.next(e);
      },
    ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await _dio.delete<T>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }
}