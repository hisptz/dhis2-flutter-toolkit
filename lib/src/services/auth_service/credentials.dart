import 'dart:convert';

class D2UserCredential {
  late String username;
  late String password;
  late String baseURL;

  get id {
    String systemId = baseURL.replaceAll("/", "-");
    return "${username}_$systemId";
  }

  D2UserCredential({
    required this.username,
    required this.password,
    required this.baseURL,
  });

  Map<String, String> toMap() {
    return {"username": username, "password": password, "baseURL": baseURL};
  }

  D2UserCredential.fromMap(String jsonString) {
    Map map = jsonDecode(jsonString);
    username = map["username"]!;
    password = map["password"]!;
    baseURL = map["baseURL"]!;
  }
}
