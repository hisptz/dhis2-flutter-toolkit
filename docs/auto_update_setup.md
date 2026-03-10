# Auto-Update Setup Guide

This guide walks through setting up **GitHub-based APK auto-updates** in a Flutter Android app using `D2UpdateService` and `D2UpdateDialog` from `dhis2_flutter_toolkit`.

---

## Overview

The auto-update system works in three stages:

1. **Check** — queries the GitHub Releases API for a newer version
2. **Download** — downloads the APK to device storage with progress tracking
3. **Install** — triggers the Android package installer via a native `MethodChannel`

### Toolkit classes used

| Class | Purpose |
|---|---|
| `D2UpdateService` | Checks for updates, downloads APK, triggers install |
| `D2UpdateDialog` | Ready-made dialog with release notes and progress bar |
| `D2GitHubUpdateService` | *(internal)* Fetches release info from GitHub API |

---

## Prerequisites

- A **GitHub repository** with [Releases](https://docs.github.com/en/repositories/releasing-projects-on-github) that include `.apk` assets
- For **private repos**, a GitHub Personal Access Token (classic) with `repo` scope

---

## Step 1 — Add the dependency

```yaml
# pubspec.yaml
dependencies:
  dhis2_flutter_toolkit:
    path: ../dhis2-flutter-toolkit   # or your published version
```

Run `flutter pub get`.

---

## Step 2 — Android native setup

Four files need to be created or modified under `android/`.

### 2.1 `android/gradle.properties`

Ensure both flags are present (prevents AndroidX / support-library duplicate class errors):

```properties
android.useAndroidX=true
android.enableJetifier=true
```

### 2.2 `android/app/src/main/AndroidManifest.xml`

Add the following **inside** the `<application>` tag and **outside** the `<activity>` tag:

```xml
<!-- Permissions -->
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.REQUEST_INSTALL_PACKAGES" />
```

Also **inside** the `<application>` tag, register the `FileProvider`:

```xml
<provider
    android:name="androidx.core.content.FileProvider"
    android:authorities="${applicationId}.fileprovider"
    android:exported="false"
    android:grantUriPermissions="true">
    <meta-data
        android:name="android.support.FILE_PROVIDER_PATHS"
        android:resource="@xml/provider_paths" />
</provider>
```

> **Why?** Android 7+ (API 24) requires `FileProvider` to share file URIs with the system package installer.

### 2.3 `android/app/src/main/res/xml/provider_paths.xml`

Create this file (the `xml/` directory may not exist yet):

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths xmlns:android="http://schemas.android.com/apk/res/android">
    <external-path name="external_files" path="."/>
    <external-cache-path name="external_cache" path="."/>
    <cache-path name="cache" path="."/>
    <files-path name="files" path="."/>
</paths>
```

### 2.4 `android/app/src/main/kotlin/.../MainActivity.kt`

Replace the default `MainActivity` with a version that handles the `installApk` method channel.

> **Important:** The `CHANNEL` string must match the `channelName` you pass to `D2UpdateService` on the Dart side.

```kotlin
package com.example.your_app  // <-- your actual package name

import android.content.Intent
import android.net.Uri
import android.os.Build
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    // Must match the channelName passed to D2UpdateService
    private val CHANNEL = "com.example.your_app/installer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "installApk") {
                val filePath = call.argument<String>("filePath")
                if (filePath != null) {
                    installApk(filePath)
                    result.success(null)
                } else {
                    result.error("INVALID_ARGUMENT", "File path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun installApk(filePath: String) {
        val file = File(filePath)
        val intent = Intent(Intent.ACTION_VIEW)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            val apkUri = FileProvider.getUriForFile(
                this,
                "${applicationContext.packageName}.fileprovider",
                file
            )
            intent.setDataAndType(apkUri, "application/vnd.android.package-archive")
            intent.flags =
                Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_GRANT_READ_URI_PERMISSION
        } else {
            intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive")
            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }

        startActivity(intent)
    }
}
```

---

## Step 3 — Flutter / Dart implementation

### 3.1 Create a GitHub references config

Store your GitHub repository details in a constants file:

```dart
// lib/constants/github_reference.dart

class GitHubReferences {
  static const String owner = 'your-org';       // GitHub username or org
  static const String repo  = 'your-app';       // Repository name
  static const String apkKey = '';               // APK name filter (e.g. 'arm64'), empty = first .apk
  static const String token = '';                // GitHub token (optional, for private repos)
}
```

### 3.2 Wire up the update check

Import the toolkit and use `D2UpdateService` + `D2UpdateDialog`:

```dart
// lib/main.dart (or wherever your home screen lives)

import 'dart:async';
import 'package:your_app/constants/github_reference.dart';
import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:flutter/material.dart';

class _MyHomePageState extends State<MyHomePage> {
  // 1. Create the service
  late final D2UpdateService _updateService = D2UpdateService(
    githubOwner: GitHubReferences.owner,
    githubRepo: GitHubReferences.repo,
    apkKey: GitHubReferences.apkKey,
    githubToken:
        GitHubReferences.token.isNotEmpty ? GitHubReferences.token : null,
    // Must match the CHANNEL in MainActivity.kt
    channelName: 'com.example.your_app/installer',
  );

  @override
  void initState() {
    super.initState();
    // 2. Check after the first frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdates());
  }

  // 3. Full update flow
  Future<void> _checkForUpdates() async {
    final updateInfo = await _updateService.checkForUpdate();
    if (updateInfo == null || !mounted) return;

    final progressController = StreamController<double>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => D2UpdateDialog(
        version: updateInfo['version'] as String,
        releaseNote: (updateInfo['releaseNote'] as String?) ?? '',
        progressStream: progressController.stream,
        onUpdate: () async {
          final filePath = await _updateService.downloadAPK(
            updateInfo['apk_url'] as String,
            (received, total) {
              if (total != -1) progressController.add(received / total);
            },
          );
          await progressController.close();

          if (!mounted) return;
          if (filePath != null) {
            await _updateService.installAPK(filePath);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to download update')),
            );
          }
          if (mounted) Navigator.of(context).pop();
        },
      ),
    );
  }

  // ... rest of your widget build
}
```

---

## API Reference

### `D2UpdateService`

| Constructor parameter | Type | Default | Description |
|---|---|---|---|
| `githubOwner` | `String` | *required* | GitHub user or organisation |
| `githubRepo` | `String` | *required* | Repository name |
| `apkKey` | `String` | `''` | Substring to match when selecting the APK asset. Empty picks the first `.apk` |
| `githubToken` | `String?` | `null` | Personal access token for private repos |
| `channelName` | `String` | `'com.example.dhis2_toolkit/installer'` | Native MethodChannel name — **must match** `MainActivity.kt` |

| Method | Returns | Description |
|---|---|---|
| `checkForUpdate()` | `Future<Map<String, dynamic>?>` | Returns `{version, apk_url, releaseNote}` if a newer release exists, `null` otherwise. Only runs on Android. |
| `downloadAPK(url, onProgress)` | `Future<String?>` | Downloads the APK and returns the local file path. `onProgress(received, total)` fires during download. |
| `installAPK(filePath)` | `Future<void>` | Invokes the native installer via MethodChannel. |

### `D2UpdateDialog`

| Parameter | Type | Description |
|---|---|---|
| `version` | `String` | New version string displayed in the title |
| `releaseNote` | `String` | Changelog text shown under "What's new" |
| `progressStream` | `Stream<double>` | Progress values from `0.0` to `1.0` |
| `onUpdate` | `Future<void> Function()` | Called when user taps **Update**. Run download + install here. The dialog does **not** auto-close — call `Navigator.of(context).pop()` when done. |
| `onSkip` | `VoidCallback?` | Optional. Called when user taps **Skip**. Defaults to popping the dialog. |

---

## Setup Checklist

- [ ] `dhis2_flutter_toolkit` added to `pubspec.yaml`
- [ ] `android.useAndroidX=true` in `gradle.properties`
- [ ] `android.enableJetifier=true` in `gradle.properties`
- [ ] `INTERNET` permission in `AndroidManifest.xml`
- [ ] `REQUEST_INSTALL_PACKAGES` permission in `AndroidManifest.xml`
- [ ] `FileProvider` declared in `AndroidManifest.xml`
- [ ] `res/xml/provider_paths.xml` created
- [ ] `MainActivity.kt` implements `installApk` MethodChannel
- [ ] `channelName` in Dart matches `CHANNEL` in Kotlin
- [ ] GitHub repo has releases with `.apk` assets attached

---

## How GitHub Releases should look

1. Create a release with a **tag** like `v1.2.0` (the leading `v` is stripped automatically)
2. Attach the `.apk` file(s) as release assets
3. Write release notes in the body — these are shown in the dialog under "What's new"

If `apkKey` is set (e.g. `'arm64'`), only assets whose filename contains that substring and ends with `.apk` are matched. If `apkKey` is empty, the first `.apk` asset is used.

---

## Troubleshooting

| Error | Cause | Fix |
|---|---|---|
| `Duplicate class android.support.v4.*` | Old support lib pulled by a transitive dependency | Add `android.enableJetifier=true` to `gradle.properties` |
| `Couldn't find meta-data for provider with authority *.fileprovider` | `FileProvider` not declared in manifest | Add the `<provider>` block to `AndroidManifest.xml` |
| `Required named parameter 'generatorVersion' must be provided` | `objectbox.g.dart` generated with an older objectbox version | Run `flutter pub upgrade objectbox objectbox_generator && dart run build_runner build --delete-conflicting-outputs` in the toolkit |
| `PlatformException: installApk` method not found | MethodChannel name mismatch | Ensure `channelName` in Dart matches `CHANNEL` in `MainActivity.kt` |
