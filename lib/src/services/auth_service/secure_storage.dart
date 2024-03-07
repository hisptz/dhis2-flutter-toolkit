import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class D2SecureStorageService {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> get(String key) async {
    return await storage.read(key: key);
  }

  Future<void> set(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  Future<void> setObject(String key, Object object) async {
    String objectString = jsonEncode(object);
    return await set(key, objectString);
  }

  Future<T?> getObject<T extends Object>(String key) async {
    String? objectString = await get(key);
    if (objectString == null) {
      return null;
    }
    try {
      return jsonDecode(objectString) as T;
    } catch (e) {
      throw "Invalid object obtained at key $key: ${e.toString()}";
    }
  }

  Future<void> delete(String key) async {
    return await storage.delete(key: key);
  }
}
