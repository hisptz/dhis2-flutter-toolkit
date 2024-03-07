import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';

import 'client.dart';
import 'credentials.dart';
import 'preferences.dart';

/// Main entry point of the authentication service. This service allows you to
///
///  - Login a user: Supports both offline and online login
///  - Get the logged user: Get the current logged in user
///  - Log out a user: Logout a user
///  - Manage a user: Add or delete a user. (An easier way of adding a user is through logging them in)
///
class D2AuthService {
  List<D2UserCredential> getUsers() {
    List<String> users = preferences?.getStringList("users") ?? [];
    if (users.isEmpty) {
      return [].cast<D2UserCredential>();
    }
    return users.map<D2UserCredential>(D2UserCredential.fromMap).toList() ?? [];
  }

  Future setLoggedInUser(D2UserCredential credentials) async {
    return await preferences?.setString("loggedInUser", credentials.id);
  }

  /// Logs out the user, if deleteData is passed, all user associated data will be deleted.
  ///
  ///
  Future logoutUser({bool deleteData = false}) async {
    D2UserCredential? credential = currentUser();
    if (credential == null) {
      throw "No logged in user";
    }

    if (deleteData) {
      await deleteDbFiles(credential.id);
    }
    return await preferences?.setString("loggedInUser", "");
  }

  /// Delete all user related data. Pass the user Id as the store id.
  ///
  Future deleteDbFiles(String storeId) async {
    Directory docDir = await getApplicationDocumentsDirectory();
    Directory('${docDir.path}/$storeId').delete();
  }

  /// Permanently deletes an offline user from the system along with associated metadata and data.
  ///
  Future deleteUser(D2UserCredential credentials) async {
    //Delete user data first
    await deleteDbFiles(credentials.id);
    //Delete them from the user's list
    List<D2UserCredential> users = getUsers();
    users.removeWhere((element) => element.id == credentials.id);
    List<String> usersPayload =
        users.map((e) => jsonEncode(e.toMap())).toList();
    await preferences?.setStringList("users", usersPayload);
    await deleteDbFiles(credentials.id);
  }

  Future saveUser(D2UserCredential credentials) async {
    List<D2UserCredential> users = getUsers();
    D2UserCredential? updatedUser = users
        .firstWhereOrNull((D2UserCredential user) => user.id == credentials.id);
    if (updatedUser != null) {
      int index = users.indexOf(credentials);
      users[index] = credentials;
    }
    users.add(credentials);
    List<String> usersPayload =
        users.map((e) => jsonEncode(e.toMap())).toList();

    return await preferences?.setStringList("users", usersPayload);
  }

  D2UserCredential? getLoggedInUser() {
    String? loggedInUserId = preferences?.getString("loggedInUser");
    if (loggedInUserId == null) {
      return null;
    }

    if (loggedInUserId.isEmpty) {
      return null;
    }

    List<D2UserCredential> users = getUsers();
    D2UserCredential? user =
        users.firstWhereOrNull((element) => element.id == loggedInUserId);
    return user;
  }

  Future<bool> verifyOnline(D2UserCredential credentials) async {
    D2HttpClientService client = D2HttpClientService(credentials);
    Map? data = await client.httpGet<Map>("me");
    if (data == null) {
      throw "Error logging in.";
    }
    if (data["httpStatusCode"] == 401) {
      throw "Invalid username or password";
    }
    if (data["username"] == credentials.username) {
      await setLoggedInUser(credentials);
      saveUser(credentials);
      return true;
    }
    return false;
  }

  //TODO: The logic to verify the user is not as strong. Improve it using encryption
  Future<bool> verifyUser(D2UserCredential credentials,
      {bool offlineFirst = false}) async {
    List<D2UserCredential> users = getUsers();
    if (offlineFirst) {
      D2UserCredential? user =
          users.firstWhereOrNull((element) => element.id == credentials.id);
      if (user == null) {
        return await verifyOnline(credentials);
      }
      //TODO: This looks terrible.
      if (credentials.password != user.password) {
        throw "Invalid password";
      }
      return true;
    }

    return await verifyOnline(credentials);
  }

  /// Gets the current logged in user. Returns null if there is no current logged in user
  ///
  D2UserCredential? currentUser() {
    return getLoggedInUser();
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
      return credentials;
    } else {
      throw "Error logging in";
    }
  }
}
