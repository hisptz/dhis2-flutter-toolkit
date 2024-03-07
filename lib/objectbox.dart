import 'package:dhis2_flutter_toolkit/dhis2_flutter_toolkit.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart'; // created by `flutter pub run build_runner build`

// ObjectBox? db;

class ObjectBox {
  /// The Store of this app.
  final Store store;
  final String storeId;

  ObjectBox._create(this.store, this.storeId) {
    // Add any additional setup code, e.g. build queries.
  }

  static Future<ObjectBox> createTest() async {
    final store = await openStore(
      directory: "memory:test-db",
    );
    return ObjectBox._create(store, "test");
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create(D2UserCredential credentials) async {
    String storeId = credentials.id;
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, storeId),
    );
    return ObjectBox._create(store, storeId);
  }
}
