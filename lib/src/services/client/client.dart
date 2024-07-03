import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../auth_service/credentials.dart';

class D2ClientService {
  D2UserCredential credentials;

  D2ClientService(this.credentials);

  D2ClientService.initialize(
      {required String username,
      required String password,
      required String baseURL})
      : credentials = D2UserCredential(
            username: username, password: password, baseURL: baseURL);

  get username {
    return credentials.username;
  }

  get password {
    return credentials.password;
  }

  get baseURL {
    return credentials.baseURL;
  }

  get headers {
    return {
      "Authorization":
          "Basic ${base64Encode(utf8.encode('$username:$password'))}",
      "Content-Type": "application/json"
    };
  }

  Uri get uri {
    return Uri.parse("https://$baseURL/api");
  }

  Uri getApiUrl(String url, {Map<String, String>? queryParameters}) {
    return uri.replace(
        pathSegments: [...uri.pathSegments, ...url.split("/")],
        queryParameters: queryParameters);
  }

  //This is the function that sends a Post Request to the DHIS2 Instance
//The function creates a new entity in the DHIS2 Instance Server
//This method accepts url String, query parameters, body of Json data and returns a Map
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

//This is the function that sends a Put Request to the DHIS2 Instance with a JSON body
//The function updates an existing entity in the DHIS2 Instance Server
//This method accepts url String, query parameters, body of Json data and returns a response object
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

//This is the function that sends a Delete Request to the DHIS2 Instance
//The function deletes an existing entity in the DHIS2 Instance Server
//This method accepts url String, query parameters and returns a response object
  Future<T> httpDelete<T>(
    String url, {
    Map<String, String>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    http.Response response = await http.delete(apiUrl, headers: headers);
    return jsonDecode(response.body) as T;
  }

//This is the function that sends a Get Request to the DHIS2 Instance
//The function Reads entities in the DHIS2 Instance Server
//This method accepts url String, query parameters and returns a response object
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

//This is the function that sends a Get Request to the DHIS2 Instance
//The function Reads entities in the DHIS2 Instance Server
//This method accepts url String, query parameters and returns a response object
  Future<Uint8List> httpGetFile(
    String url, {
    Map<String, String>? queryParameters,
  }) async {
    Uri apiUrl = getApiUrl(url, queryParameters: queryParameters);
    http.Response response = await http.get(apiUrl, headers: headers);
    if ([200, 304].contains(response.statusCode)) {
      return response.bodyBytes;
    } else {
      throw response.body;
    }
  }

//This is the function that sends a Get Request to the DHIS2 Instance
//The function Reads entities in the DHIS2 Instance Server
  ///This method accepts url String, query parameters and returns a response object with a page size of 1
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

  ///This method returns a String of server url
  @override
  String toString() {
    return '$baseURL => $username : $password';
  }
}
