import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<String?> login() async {
    try {
      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          dotenv.env['AUTH0_CLIENT_ID']!,
          'com.auth0.flutterapp://login-callback',
          issuer: 'https://${dotenv.env['AUTH0_DOMAIN']}',
          scopes: ['openid', 'profile', 'email'],
        ),
      );

      if (result != null) {
        print('Login successful. Access token: ${result.accessToken}');
        await _secureStorage.write(
            key: 'refresh_token', value: result.refreshToken);
        return result.accessToken;
      } else {
        print('Login failed: result is null');
      }
    } catch (e, s) {
      print('Login error: $e - stack: $s');
    }
    return null;
  }

  Future<String?> getAccessToken() async {
    final storedRefreshToken = await _secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) {
      return null;
    }

    try {
      final TokenResponse? result = await _appAuth.token(
        TokenRequest(
          dotenv.env['AUTH0_CLIENT_ID']!,
          dotenv.env['AUTH0_REDIRECT_URI']!,
          issuer: 'https://${dotenv.env['AUTH0_DOMAIN']}',
          refreshToken: storedRefreshToken,
        ),
      );

      if (result != null) {
        return result.accessToken;
      }
    } catch (e, s) {
      print('Error getting access token: $e - stack: $s');
    }

    return null;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'refresh_token');
  }
}
