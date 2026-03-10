import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'github-update-service.dart';
class D2UpdateService {
  D2UpdateService({
    required this.githubOwner,
    required this.githubRepo,
    this.apkKey = '',
    this.githubToken,
    this.channelName = 'com.example.dhis2_toolkit/installer',
  })  : _gitHubService = D2GitHubUpdateService(),
        _dio = Dio();

  final String githubOwner;
  final String githubRepo;
  final String apkKey;
  final String? githubToken;
  final String channelName;

  final D2GitHubUpdateService _gitHubService;
  final Dio _dio;

  late final MethodChannel _platform = MethodChannel(channelName);
  Future<Map<String, dynamic>?> checkForUpdate() async {
    if (!Platform.isAndroid) return null;

    final releaseInfo = await _gitHubService.getLatestRelease(
      owner: githubOwner,
      repo: githubRepo,
      apkKey: apkKey,
      token: githubToken,
    );
    if (releaseInfo == null) return null;

    final serverVersion = releaseInfo['version'] as String?;
    final apkUrl = releaseInfo['apk_url'] as String?;
    final releaseNote = releaseInfo['releaseNote'] as String?;

    if (serverVersion == null || apkUrl == null) return null;

    final packageInfo = await PackageInfo.fromPlatform();
    if (_isNewerVersion(serverVersion, packageInfo.version)) {
      return {
        'version': serverVersion,
        'apk_url': apkUrl,
        'releaseNote': releaseNote ?? '',
      };
    }
    return null;
  }

 
  Future<String?> downloadAPK(
    String url,
    void Function(int received, int total) onProgress,
  ) async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) return null;
      final filename = Uri.parse(url).pathSegments.last;
      final filePath = '${directory.path}/$filename';
      debugPrint('D2UpdateService: Downloading APK → $filePath');
      await _dio.download(url, filePath, onReceiveProgress: onProgress);
      return filePath;
    } catch (e) {
      debugPrint('D2UpdateService: Error downloading APK: $e');
      return null;
    }
  }

  
  Future<void> installAPK(String filePath) async {
    try {
      await _platform.invokeMethod('installApk', {'filePath': filePath});
    } on PlatformException catch (e) {
      debugPrint('D2UpdateService: PlatformException during install: ${e.message}');
    } catch (e) {
      debugPrint('D2UpdateService: Error triggering installation: $e');
    }
  }

  bool _isNewerVersion(String serverVersion, String currentVersion) {
    final server = _parseVersion(serverVersion);
    final current = _parseVersion(currentVersion);
    for (int i = 0; i < server.length; i++) {
      if (i >= current.length) return true;
      if (server[i] > current[i]) return true;
      if (server[i] < current[i]) return false;
    }
    return false;
  }

  List<int> _parseVersion(String version) {
    return version.split('.').map((p) => int.tryParse(p) ?? 0).toList();
  }
}