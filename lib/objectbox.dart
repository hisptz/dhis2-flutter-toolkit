import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'objectbox.g.dart';
import 'src/services/entry.dart'; // created by `flutter pub run build_runner build`

/// This class represents a Objectbox store instance used throughout the application.
class D2ObjectBox {
  /// The underlying store instance.
  final Store store;

  /// Identifier for the store instance.
  final String storeId;

  /// Private constructor for creating a [D2ObjectBox] instance.
  ///
  /// Use [createTest] or [create] static methods to instantiate [D2ObjectBox].
  D2ObjectBox._create(this.store, this.storeId) {
    // Add any additional setup code, e.g. build queries.
  }

  /// Creates a test instance of [D2ObjectBox] with an in-memory store.
  ///
  /// Returns a [Future] that completes with the created [D2ObjectBox] instance.
  static Future<D2ObjectBox> createTest() async {
    final store = await openStore(
      directory: "memory:test-db",
    );
    return D2ObjectBox._create(store, "test");
  }

  /// Creates an instance of [D2ObjectBox] for use throughout the application.
  ///
  /// - Takes [credentials] of type [D2UserCredential] to identify the store.
  ///
  /// Returns a [Future] that completes with the created [D2ObjectBox] instance.
  static Future<D2ObjectBox> create(D2UserCredential credentials) async {
    String storeId = credentials.id;
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(
      directory: p.join(docsDir.path, storeId),
    );
    return D2ObjectBox._create(store, storeId);
  }
}
