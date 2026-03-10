import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
class D2GitHubUpdateService {
  final Dio _dio = Dio();
  Future<Map<String, dynamic>?> getLatestRelease({
    required String owner,
    required String repo,
    String apkKey = '',
    String? token,
  }) async {
    try {
      final url = 'https://api.github.com/repos/$owner/$repo/releases/latest';
      final headers = <String, String>{
        'Accept': 'application/vnd.github.v3+json',
      };
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      final response = await _dio.get(url, options: Options(headers: headers));
      if (response.statusCode != 200) return null;

      final data = response.data as Map<String, dynamic>;
      final tagName = data['tag_name'] as String;
      final body = (data['body'] as String?) ?? '';
      final version =
          tagName.startsWith('v') ? tagName.substring(1) : tagName;
      final assets = data['assets'] as List<dynamic>;

      String? apkUrl;
      for (final asset in assets) {
        final String name = asset['name'] as String;
        if (name.endsWith('.apk')) {
          if (apkKey.isEmpty || name.contains(apkKey)) {
            apkUrl = asset['browser_download_url'] as String?;
            break;
          }
        }
      }

      if (apkUrl != null) {
        return {'version': version, 'apk_url': apkUrl, 'releaseNote': body};
      }
    } catch (e) {
      debugPrint('D2GitHubUpdateService: Error fetching release info: $e');
    }
    return null;
  }
}
