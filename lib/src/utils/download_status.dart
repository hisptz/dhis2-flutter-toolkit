enum Status { initialized, syncing, complete }

class DownloadStatus {
  String label;
  int? synced;
  int? total;

  Status status;

  DownloadStatus(
      {this.synced, this.total, required this.status, required this.label});

  DownloadStatus increment() {
    if (synced != null) {
      synced = synced! + 1;
    }
    return this;
  }

  DownloadStatus complete() {
    status = Status.complete;
    return this;
  }
}
