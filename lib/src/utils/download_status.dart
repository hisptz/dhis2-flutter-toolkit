enum Status { initialized, syncing, complete }

class D2SyncStatus {
  String label;
  int? synced;
  int? total;

  Status status;

  D2SyncStatus(
      {this.synced, this.total, required this.status, required this.label});

  D2SyncStatus increment() {
    if (synced != null) {
      synced = synced! + 1;
    }
    return this;
  }

  D2SyncStatus complete() {
    status = Status.complete;
    return this;
  }
}
