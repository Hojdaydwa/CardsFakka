import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://mobile.vodafone.com.eg';
  static const String authPath = '/checkSeamless/realms/vf-realm/protocol/openid-connect/auth';

  static final Map<String, String> _defaultHeaders = {
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
  };

  final http.Client _client = http.Client();

  Future<http.Response> get(String path, {Map<String, String>? queryParams, Map<String, String>? extraHeaders}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: queryParams);
    final headers = Map<String, String>.from(_defaultHeaders);
    if (extraHeaders != null) headers.addAll(extraHeaders);

    return await _client.get(uri, headers: headers);
  }

  Future<http.Response> post(String path, {Map<String, dynamic>? body, Map<String, String>? extraHeaders}) async {
    final uri = Uri.parse('$baseUrl$path');
    final headers = Map<String, String>.from(_defaultHeaders);
    headers['Content-Type'] = 'application/json';
    if (extraHeaders != null) headers.addAll(extraHeaders);

    return await _client.post(uri, headers: headers, body: jsonEncode(body));
  }

  void dispose() {
    _client.close();
  }
}
