import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jammies_app/services/api_url.dart';

class ApiClient {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiUrl));
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'accessToken');
          print("TOKEN DIO DEBUG: $token");
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['Content-Type'] = 'application/json';
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final requestOptions = error.requestOptions;

          if (error.response?.statusCode == 401 &&
              !requestOptions.extra.containsKey('retry')) {
            requestOptions.extra['retry'] = true;

            final refreshToken = await _storage.read(key: 'refreshToken');
            if (refreshToken == null) return handler.next(error);

            try {
              final refreshResponse = await _dio.post(
                '/auth/refresh',
                data: {'refreshToken': refreshToken},
                options: Options(headers: {'Content-Type': 'application/json'}),
              );

              final newAccessToken = refreshResponse.data['accessToken'];
              await _storage.write(key: 'access_token', value: newAccessToken);

              // Retry original request
              final newOptions = Options(
                method: requestOptions.method,
                headers: {
                  ...requestOptions.headers,
                  'Authorization': 'Bearer $newAccessToken',
                },
              );

              final retryResponse = await _dio.request(
                requestOptions.path,
                data: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
                options: newOptions,
              );

              return handler.resolve(retryResponse);
            } catch (_) {
              await _storage.deleteAll();
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  // GET
  Future<Response> get(String endpoint) async {
    return _dio.get(endpoint);
  }

  // POST (JSON)
  Future<Response> post(String endpoint, Map<String, dynamic> data) async {
    return _dio.post(endpoint, data: data);
  }

  // PUT
  Future<Response> put(String endpoint, Map<String, dynamic> data) async {
    return _dio.put(endpoint, data: data);
  }

  // DELETE
  Future<Response> delete(String endpoint) async {
    return _dio.delete(endpoint);
  }

  // POST Multipart con campos opcionales
  Future<Response> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    MultipartFile? file,
  }) async {
    final formData = FormData.fromMap({
      ...fields,
      if (file != null) 'image': file,
    });

    return _dio.post(endpoint, data: formData);
  }

  // POST track (audio + cover + título)
  Future<Response> postTrack(
    String endpoint,
    String title,
    MultipartFile audio,
    MultipartFile cover,
  ) async {
    final formData = FormData.fromMap({
      'title': title,
      'audio': audio,
      'cover': cover,
    });
    return _dio.post(endpoint, data: formData);
  }
}
