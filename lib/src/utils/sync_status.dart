enum D2SyncStatusEnum { initialized, syncing, complete }

class D2SyncStatus {
  String label;
  int? synced;
  int? total;

  D2SyncStatusEnum status;

  D2SyncStatus(
      {this.synced, this.total, required this.status, required this.label});

  D2SyncStatus increment() {
    if (synced != null) {
      synced = synced! + 1;
    }
    return this;
  }

  D2SyncStatus complete() {
    status = D2SyncStatusEnum.complete;
    return this;
  }
}
