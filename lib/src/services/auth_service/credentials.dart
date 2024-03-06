import 'dart:convert';

import 'package:dhis2_flutter_toolkit/src/services/auth_service/auth_service.dart';
import 'package:dhis2_flutter_toolkit/src/services/auth_service/client.dart';

class D2UserCredential {
  String username;
  String password;
  String baseURL;

  get id {
    String systemId = baseURL.replaceAll("/", "-");
    return "${username}_$systemId";
  }

  D2UserCredential({
    required this.username,
    required this.password,
    required this.baseURL,
  });

  Future saveToPreference() async {
    await D2AuthService().saveUser(this);
  }

  Map<String, String> toMap() {
    return {"username": username, "password": password, "baseURL": baseURL};
  }

  static D2UserCredential fromPreferences(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    String baseURL = map["baseURL"]!;
    String username = map["username"]!;
    String password = map["password"]!;
    return D2UserCredential(
      username: username,
      password: password,
      baseURL: baseURL,
    );
  }

  Future<void> logout() async {
    return D2AuthService().logoutUser();
  }

  Future<bool> verifyOnline() async {
    D2HttpClientService client = D2HttpClientService(this);
    Map? data = await client.httpGet<Map>("system/info");
    if (data == null) {
      throw "Error logging in.";
    }
    if (data["httpStatusCode"] == 401) {
      throw "Invalid username or password";
    }
    await saveToPreference();
    await D2AuthService().loginUser(this);
    return true;
  }

  Future<bool> verifyOffline() async {
    return D2AuthService().verifyUser(this);
  }

  Future<bool> verify() async {
    bool verified = await verifyOffline();
    if (!verified) {
      return await verifyOnline();
    }
    await D2AuthService().loginUser(this);
    return true;
  }
}
