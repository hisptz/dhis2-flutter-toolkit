import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart';
import 'src/services/entry.dart'; // created by `flutter pub run build_runner build`

class D2ObjectBox {
  /// The Store of this app.
  final Store store;
  final String storeId;

  D2ObjectBox._create(this.store, this.storeId) {
    // Add any additional setup code, e.g. build queries.
  }

  static Future<D2ObjectBox> createTest() async {
    final store = await openStore(
      directory: "memory:test-db",
    );
    return D2ObjectBox._create(store, "test");
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<D2ObjectBox> create(D2UserCredential credentials) async {
    String storeId = credentials.id;
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, storeId),
    );
    return D2ObjectBox._create(store, storeId);
  }
}
