import 'package:dio/dio.dart';
import 'package:grupr/features/auth/data/data_sources/remote/auth_api_service.dart';

class ApiClient {
  late Dio dio;
  final AuthService _authService;

  ApiClient(this._authService) : dio = Dio() {
    dio = Dio();

    // Add the interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? accessToken = await _authService.getAccessToken();

          if (accessToken != null) {
            // Add the token to the Authorization header
            options.headers["Authorization"] = "Bearer $accessToken";
          }

          return handler.next(options); // Continue with the request
        },
        onResponse: (response, handler) {
          return handler.next(response); // Continue with the response
        },
        onError: (DioException e, handler) {
          return handler.next(e); // Continue with the error
        },
      ),
    );
  }
}
