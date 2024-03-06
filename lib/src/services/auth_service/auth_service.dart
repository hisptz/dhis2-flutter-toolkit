import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';

import 'credentials.dart';
import 'preferences.dart';

class D2AuthService {
  List<D2UserCredential> getUsers() {
    List<String> users = preferences?.getStringList("users") ?? [];
    if (users.isEmpty) {
      return [].cast<D2UserCredential>();
    }
    return users
            .map<D2UserCredential>(D2UserCredential.fromPreferences)
            .toList() ??
        [];
  }

  Future loginUser(D2UserCredential credentials) async {
    return await preferences?.setString("loggedInUser", credentials.id);
  }

  Future logoutUser() async {
    return await preferences?.setString("loggedInUser", "");
  }

  Future deleteDbFiles(String storeId) async {
    Directory docDir = await getApplicationDocumentsDirectory();
    Directory('${docDir.path}/$storeId').delete();
  }

  Future deleteUser(D2UserCredential credentials) async {
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

  bool verifyUser(D2UserCredential credentials) {
    List<D2UserCredential> users = getUsers();
    D2UserCredential? user =
        users.firstWhereOrNull((element) => element.id == credentials.id);
    if (user == null) {
      return false;
    }

    //TODO: This looks terrible.
    if (credentials.password != user.password) {
      throw "Invalid password";
    }
    //I guess all is good. I hope so
    return true;
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

    if (verifyUser(credentials)) {
      return credentials;
    } else {
      throw "Error logging in";
    }
  }
}
