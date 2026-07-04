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
  }) : _gitHubService = D2GitHubUpdateService(),
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
      debugPrint(
        'D2UpdateService: PlatformException during install: ${e.message}',
      );
    } catch (e) {
      debugPrint('D2UpdateService: Error triggering installation: $e');
    }
  }

  bool _isNewerVersion(String serverVersion, String currentVersion) {
    final server = _Version.parse(serverVersion);
    final current = _Version.parse(currentVersion);
    return server.compareTo(current) > 0;
  }
}

class _Version {
  _Version(this.core, this.preRelease);

  final List<int> core;
  final List<String> preRelease;

  factory _Version.parse(String raw) {
    // Strip build metadata (e.g. "1.0.0+build.1") and a leading "v".
    var version = raw.split('+').first.trim();
    if (version.startsWith('v') || version.startsWith('V')) {
      version = version.substring(1);
    }

    final dashIndex = version.indexOf('-');
    final corePart = dashIndex == -1
        ? version
        : version.substring(0, dashIndex);
    final preReleasePart = dashIndex == -1
        ? ''
        : version.substring(dashIndex + 1);

    final core = corePart.split('.').map((p) => int.tryParse(p) ?? 0).toList();
    final preRelease = preReleasePart.isEmpty
        ? <String>[]
        : preReleasePart.split('.').expand(_splitLabelAndNumber).toList();

    return _Version(core, preRelease);
  }

  static final _labelNumberPattern = RegExp(r'^([A-Za-z]+)(\d+)$');
  static List<String> _splitLabelAndNumber(String identifier) {
    final match = _labelNumberPattern.firstMatch(identifier);
    if (match == null) return [identifier];
    return [match.group(1)!, match.group(2)!];
  }

  /// Returns >0 if this version is newer than [other], <0 if older, 0 if equal.
  int compareTo(_Version other) {
    final length = core.length > other.core.length
        ? core.length
        : other.core.length;
    for (int i = 0; i < length; i++) {
      final a = i < core.length ? core[i] : 0;
      final b = i < other.core.length ? other.core[i] : 0;
      if (a != b) return a.compareTo(b);
    }

    // Same core version: a pre-release is *older* than a full release.
    if (preRelease.isEmpty && other.preRelease.isEmpty) return 0;
    if (preRelease.isEmpty) return 1;
    if (other.preRelease.isEmpty) return -1;

    final preLength = preRelease.length > other.preRelease.length
        ? preRelease.length
        : other.preRelease.length;
    for (int i = 0; i < preLength; i++) {
      if (i >= preRelease.length) return -1;
      if (i >= other.preRelease.length) return 1;

      final a = preRelease[i];
      final b = other.preRelease[i];
      if (a == b) continue;

      final aNum = int.tryParse(a);
      final bNum = int.tryParse(b);
      if (aNum != null && bNum != null) return aNum.compareTo(bNum);
      if (aNum != null) return -1; // numeric identifiers sort lower
      if (bNum != null) return 1;
      return a.compareTo(b);
    }
    return 0;
  }
}
