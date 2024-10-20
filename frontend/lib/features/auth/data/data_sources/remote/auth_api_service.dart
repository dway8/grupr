import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final FlutterAppAuth _appAuth = const FlutterAppAuth();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  String? _accessToken;

  Future<Map<String, String>?> login() async {
    try {
      final clientId = dotenv.env['AUTH0_CLIENT_ID'];
      final domain = dotenv.env['AUTH0_DOMAIN'];
      final audience = dotenv.env['AUTH0_AUDIENCE'];

      if (clientId == null || domain == null || audience == null) {
        throw Exception(
            'Missing environment variables: ${clientId == null ? 'AUTH0_CLIENT_ID ' : ''}${domain == null ? 'AUTH0_DOMAIN ' : ''}${audience == null ? 'AUTH0_AUDIENCE' : ''}');
      }

      final AuthorizationTokenResponse? result =
          await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          clientId,
          'com.auth0.flutterapp://login-callback',
          issuer: 'https://$domain',
          scopes: ['openid', 'profile', 'email'],
          additionalParameters: {'audience': audience},
        ),
      );

      if (result != null) {
        final accessToken = result.accessToken!;
        final userId = _getUserIdFromToken(accessToken);
        _accessToken = accessToken;
        await _secureStorage.write(
            key: 'refresh_token', value: result.refreshToken);
        return {
          'accessToken': accessToken,
          'userId': userId,
        };
      }
    } catch (e, s) {
      print('Login error: $e - stack: $s');
    }
    return null;
  }

  String _getUserIdFromToken(String accessToken) {
    try {
      final decodedToken = JwtDecoder.decode(accessToken);
      return decodedToken['sub'] ?? '';
    } catch (e) {
      print('*********** Error decoding token: $e');
      print('*********** Access token: $accessToken');
      return '';
    }
  }

  Future<String?> getAccessToken() async {
    if (_accessToken != null) {
      print('Access token is already set, returning it');
      return _accessToken;
    }

    final storedRefreshToken = await _secureStorage.read(key: 'refresh_token');
    if (storedRefreshToken == null) {
      return null;
    }

    try {
      print('Fetching access token from auth0 with refresh token');
      final TokenResponse result = await _appAuth.token(
        TokenRequest(
          dotenv.env['AUTH0_CLIENT_ID']!,
          dotenv.env['AUTH0_REDIRECT_URI']!,
          issuer: 'https://${dotenv.env['AUTH0_DOMAIN']}',
          refreshToken: storedRefreshToken,
        ),
      );

      _accessToken = result.accessToken;

      return result.accessToken;
    } catch (e, s) {
      print('Error getting access token: $e - stack: $s');
    }

    return null;
  }

  Future<void> logout() async {
    _accessToken = null;
    await _secureStorage.delete(key: 'refresh_token');
  }
}
