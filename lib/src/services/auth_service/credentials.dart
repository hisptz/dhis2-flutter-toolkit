import 'dart:convert';

/// This  class represents user credentials for authentication in the DHIS2 system.
class D2UserCredential {
  /// The username of the user.
  late String username;

  /// The password of the user.
  late String password;

  /// The base URL for the DHIS2 system.
  late String baseURL;

  /// Returns a unique identifier for the user based on the username and base URL.
  ///
  /// The base URL is sanitized by replacing "/" with "-" to form part of the unique identifier.
  get id {
    String systemId = baseURL.replaceAll("/", "-");
    return "${username}_$systemId";
  }

  /// Creates a new [D2UserCredential] instance.
  ///
  /// Takes the following parameters:
  /// - [username] The username of the user.
  /// - [password] The password of the user.
  /// - [baseURL] The base URL for the D2 system.
  D2UserCredential({
    required this.username,
    required this.password,
    required this.baseURL,
  });

  /// Converts the [D2UserCredential] instance to a map.
  ///
  /// Returns a [Map] with keys "username", "password", and "baseURL".
  Map<String, String> toMap() {
    return {"username": username, "password": password, "baseURL": baseURL};
  }

  /// Creates a new [D2UserCredential] instance from a JSON string.
  ///
  /// Takes a [jsonString] representing the user's credentials.
  D2UserCredential.fromMap(String jsonString) {
    Map map = jsonDecode(jsonString);
    username = map["username"]!;
    password = map["password"]!;
    baseURL = map["baseURL"]!;
  }
}
