import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../client/client.dart';
import 'credentials.dart';
import 'secure_storage.dart';

/// Main entry point of the authentication service. This service allows you to
///
///  - Login a user: Supports both offline and online login
///  - Get the logged user: Get the current logged in user
///  - Log out a user: Logout a user
///  - Manage a user: Add or delete a user. (An easier way of adding a user is through logging them in)
///
class D2AuthService {
  D2SecureStorageService storageService = D2SecureStorageService();

  Future<List<D2UserCredential>> _getUsers() async {
    List? users = await storageService.getObject("users");
    if (users == null) {
      return [].cast<D2UserCredential>();
    }
    if (users.isEmpty) {
      return [].cast<D2UserCredential>();
    }
    return users
        .map<D2UserCredential>((user) => D2UserCredential.fromMap(user))
        .toList();
  }

  Future _setLoggedInUser(D2UserCredential credentials) async {
    return await storageService.set("loggedInUser", credentials.id);
  }

  /// Logs out the user, if deleteData is passed, all user associated data will be deleted.
  ///
  ///
  Future logoutUser({bool deleteData = false}) async {
    D2UserCredential? credential = await currentUser();
    if (credential == null) {
      throw "No logged in user";
    }

    if (deleteData) {
      await _deleteDbFiles(credential.id);
    }
    return await storageService.set("loggedInUser", "");
  }

  /// Delete all user related data. Pass the user Id as the store id.
  ///
  Future _deleteDbFiles(String storeId) async {
    Directory docDir = await getApplicationDocumentsDirectory();
    await Directory('${docDir.path}/$storeId').delete(recursive: true);
  }

  /// Permanently deletes an offline user from the system along with associated metadata and data.
  ///
  Future deleteUser(D2UserCredential credentials) async {
    //Delete user data first
    await _deleteDbFiles(credentials.id);
    //Delete them from the user's list
    List<D2UserCredential> users = await _getUsers();
    users.removeWhere((element) => element.id == credentials.id);
    List<String> usersPayload =
        users.map((e) => jsonEncode(e.toMap())).toList();
    await storageService.setObject("users", usersPayload);
    await _deleteDbFiles(credentials.id);
  }

  Future saveUser(D2UserCredential credentials) async {
    List<D2UserCredential> users = await _getUsers();
    D2UserCredential? updatedUser = users
        .firstWhereOrNull((D2UserCredential user) => user.id == credentials.id);
    if (updatedUser != null) {
      int index = users.indexWhere((element) => credentials.id == element.id);
      users[index] = credentials;
    }
    users.add(credentials);
    List<String> usersPayload =
        users.map((e) => jsonEncode(e.toMap())).toList();

    return await storageService.setObject("users", usersPayload);
  }

  Future<D2UserCredential?> _getLoggedInUser() async {
    String? loggedInUserId = await storageService.get("loggedInUser");
    if (loggedInUserId == null) {
      return null;
    }

    if (loggedInUserId.isEmpty) {
      return null;
    }

    List<D2UserCredential> users = await _getUsers();
    D2UserCredential? user =
        users.firstWhereOrNull((element) => element.id == loggedInUserId);
    return user;
  }

  Future<bool> _verifyOnline(D2UserCredential credentials) async {
    D2ClientService client = D2ClientService(credentials);
    try {
      Map? data = await client.httpGet<Map>("me");
      if (data == null) {
        throw "Error logging in.";
      }
      if (data["httpStatusCode"] == 401) {
        throw "Invalid username or password";
      }
      if (data["username"] == credentials.username) {
        saveUser(credentials);
        return true;
      }
      return false;
    } catch (e) {
      String errorString = e.toString();
      if (errorString.contains("401")) {
        throw "Invalid username or password";
      }
      rethrow;
    }
  }

  //TODO: The logic to verify the user is not as strong. Improve it using encryption
  Future<bool> _verifyOffline(D2UserCredential credentials) async {
    List<D2UserCredential> users = await _getUsers();
    D2UserCredential? user =
        users.firstWhereOrNull((element) => element.id == credentials.id);
    if (user == null) {
      return false;
    }
    if (credentials.password != user.password) {
      throw "Invalid password";
    }
    await Future.delayed(const Duration(seconds: 1)); //Artificial delay
    return true;
  }

  Future<bool> verifyUser(D2UserCredential credentials,
      {bool offlineFirst = false}) async {
    if (offlineFirst) {
      bool verified = await _verifyOffline(credentials);
      if (!verified) {
        return await _verifyOnline(credentials);
      } else {
        return verified;
      }
    }

    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult.firstOrNull == ConnectivityResult.none) {
      //Try logging in offline
      return _verifyOffline(credentials);
    }

    return await _verifyOnline(credentials).timeout(const Duration(minutes: 2),
        onTimeout: () => _verifyOffline(credentials));
  }

  /// Gets the current logged in user. Returns null if there is no current logged in user
  ///
  Future<D2UserCredential?> currentUser() async {
    return _getLoggedInUser();
  }

  /// Logs in the user with the specified credentials.
  /// By default this will check if the user is online and try to verify the credentials online.
  /// If the user is offline, this will check if the user has logged in before. If they have, they will be authenticated offline.
  /// To perform offline first login, set `offlineFirst` to true
  ///
  Future<D2UserCredential> login(
      {required String baseURL,
      required String username,
      required password,
      offlineFirst = false}) async {
    D2UserCredential credentials = D2UserCredential(
        username: username, password: password, baseURL: baseURL);

    if (await verifyUser(credentials, offlineFirst: offlineFirst)) {
      await _setLoggedInUser(credentials);
      return credentials;
    } else {
      throw "Error logging in";
    }
  }
}
