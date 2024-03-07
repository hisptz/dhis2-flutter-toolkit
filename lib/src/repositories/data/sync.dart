
import '../../../dhis2_flutter_toolkit.dart';

abstract class SyncableRepository<T> {
  //Sync that one entity to the server
  Future syncOne(D2ClientService client, T entity);

  Future syncMany(D2ClientService client);
}
