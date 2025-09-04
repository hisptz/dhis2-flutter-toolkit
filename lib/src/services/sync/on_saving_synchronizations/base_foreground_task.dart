import 'dart:async';

import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';

abstract class BaseForegroundTask {
  D2ObjectBox? db;
  D2ClientService? client;
  D2User? user;
  StreamController<D2SyncStatus>? activeController =
      StreamController<D2SyncStatus>();
  abstract String taskName;
  abstract String taskId;
  bool background;

  Future<void> init() async {
    D2UserCredential? credentials = await D2AuthService().currentUser();
    if (credentials == null) {
      throw Exception('Error getting user login information');
    }

    db = await D2ObjectBox.create(credentials);
    user = D2UserRepository(db!).get();
    client = D2ClientService(credentials);
    activeController = StreamController<D2SyncStatus>();
  }

  BaseForegroundTask({this.background = false});
}
