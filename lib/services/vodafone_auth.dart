import 'dart:convert';
import 'package:http/http.dart' as http;

class VodafoneCashAuth {
  static const String _authUrl =
      'http://mobile.vodafone.com.eg/checkSeamless/realms/vf-realm/protocol/openid-connect/auth?client_id=ana-vodafone-app-seamless';

  static const Map<String, String> _baseHeaders = {
    'User-Agent': 'okhttp/4.12.0',
    'Connection': 'Keep-Alive',
    'Accept-Encoding': 'gzip',
    'x-agent-operatingsystem': '16',
    'clientId': 'AnaVodafoneAndroid',
    'Accept-Language': 'ar',
    'x-agent-device': 'Samsung SM-A165F',
    'x-agent-version': '2025.11.1',
    'x-agent-build': '1063',
    'digitalId': '',
    'device-id': 'b26ba335813fad21',
    'If-Modified-Since': 'Thu, 02 Apr 2026 09:09:07 GMT',
  };

  /// بدء عملية المصادقة - يجيب redirect/auth URL
  static Future<String> authenticate() async {
    final response = await http.get(
      Uri.parse(_authUrl),
      headers: _baseHeaders,
    );
    return response.body;
  }

  /// عمل Request مخصص لأي endpoint
  static Future<http.Response> customRequest({
    required String url,
    String method = 'GET',
    Map<String, String>? extraHeaders,
    dynamic body,
  }) async {
    final headers = Map<String, String>.from(_baseHeaders);
    if (extraHeaders != null) headers.addAll(extraHeaders);

    switch (method.toUpperCase()) {
      case 'POST':
        return await http.post(
          Uri.parse(url),
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      case 'GET':
      default:
        return await http.get(Uri.parse(url), headers: headers);
    }
  }
}
