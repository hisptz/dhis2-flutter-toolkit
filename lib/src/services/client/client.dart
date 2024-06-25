import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../auth_service/credentials.dart';

/// This is a collection of client services for interacting with DHIS2 APIs.
class D2ClientService {
  /// User credentials for accessing DHIS2.
  D2UserCredential credentials;

  /// Creates a new instance of [D2ClientService].
  ///
  /// [credentials] User credentials for accessing DHIS2.
  D2ClientService(this.credentials);

  /// Initializes the [D2ClientService] with provided credentials.
  ///
  /// - [username] The username for authentication.
  /// - [password] The password for authentication.
  /// - [baseURL] The base URL of the DHIS2 instance.
  D2ClientService.initialize(
      {required String username,
      required String password,
      required String baseURL})
      : credentials = D2UserCredential(
            username: username, password: password, baseURL: baseURL);

  /// Returns the username.
  get username {
    return credentials.username;
  }

  /// Returns the password.
  get password {
    return credentials.password;
  }

  /// Returns the base URL.
  get baseURL {
    return credentials.baseURL;
  }

  /// Returns the headers for HTTP requests.
  get headers {
    return {
      "Authorization":
          "Basic ${base64Encode(utf8.encode('$username:$password'))}",
      "Content-Type": "application/json"
    };
  }

  /// Returns the URI for the DHIS2 API.
  Uri get uri {
    return Uri.parse("https://$baseURL/api");
  }

  /// Returns the API URL with optional query parameters.
  ///
  /// - [url] The URL endpoint.
  /// - [queryParameters] Optional query parameters.
  Uri getApiUrl(String url, {Map<String, String>? queryParameters}) {
    return uri.replace(
        pathSegments: [...uri.pathSegments, ...url.split("/")],
        queryParameters: queryParameters);
  }

  /// Sends a POST request to the DHIS2 instance.
  ///
  /// This method creates a new entity in the DHIS2 instance server.
  ///
  /// - [url] The URL endpoint.
  /// - [body] The JSON data body.
  /// - [queryParameters] Optional query parameters.
  ///
  /// Returns a Future representing the result of the POST request.
  Future<T> httpPost<T>(
    String url,
    body, {
    Map<String, String>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    http.Response response = await http.post(
      apiUrl,
      headers: headers,
      body: jsonEncode(body),
    );
    return jsonDecode(response.body) as T;
  }

  /// Sends a PUT request to the DHIS2 instance.
  ///
  /// This method updates an existing entity in the DHIS2 instance server.
  ///
  /// - [url] The URL endpoint.
  /// - [body] The JSON data body.
  /// - [queryParameters] Optional query parameters.
  ///
  /// Returns a Future representing the result of the PUT request.
  Future<T> httpPut<T>(
    String url,
    body, {
    Map<String, String>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    http.Response response = await http.put(
      apiUrl,
      headers: headers,
      body: jsonEncode(body),
    );

    return jsonDecode(response.body) as T;
  }

  /// Sends a DELETE request to the DHIS2 instance.
  ///
  /// This method deletes an existing entity in the DHIS2 instance server.
  ///
  /// - [url] The URL endpoint.
  /// - [queryParameters] Optional query parameters.
  ///
  /// Returns a Future representing the result of the DELETE request.
  Future<T> httpDelete<T>(
    String url, {
    Map<String, String>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    http.Response response = await http.delete(apiUrl, headers: headers);
    return jsonDecode(response.body) as T;
  }

  /// Sends a GET request to the DHIS2 instance.
  ///
  /// This method reads entities in the DHIS2 instance server.
  ///
  /// - [url] The URL endpoint.
  /// - [queryParameters] Optional query parameters.
  ///
  /// Returns a Future representing the result of the GET request.
  Future<T?> httpGet<T>(
    String url, {
    Map<String, String>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    http.Response response = await http.get(apiUrl, headers: headers);
    if ([200, 304].contains(response.statusCode)) {
      try {
        return jsonDecode(response.body) as T;
      } catch (e) {
        debugPrint(e.toString());
        return null;
      }
    } else {
      throw response.body;
    }
  }

  /// Sends a GET request to the DHIS2 instance with pagination.
  ///
  /// This method reads entities in the DHIS2 instance server with pagination.
  ///
  /// - [url] The URL endpoint.
  /// - [queryParameters] Optional query parameters.
  ///
  /// Returns a Future representing the result of the GET request with a page size of 1.
  Future<T?> httpGetPagination<T>(
    String url, {
    Map<String, String>? queryParameters,
  }) async {
    Map<String, String> dataQueryParameters = {
      'totalPages': 'true',
      'pageSize': '1',
      'fields': 'none',
    };
    dataQueryParameters.addAll(queryParameters ?? {});
    return await httpGet<T>(url, queryParameters: dataQueryParameters);
  }

  /// Returns a String of server url containing the server URL, username, and password.
  @override
  String toString() {
    return '$baseURL => $username : $password';
  }
}
