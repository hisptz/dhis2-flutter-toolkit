import 'dart:ui';

enum D2SyncStatusEnum { initialized, syncing, complete }

class D2SyncStatus {
  String label;
  int? synced = 0;
  int? total;

  D2SyncStatusEnum status;

  D2SyncStatus? subProcess;

  D2SyncStatus(
      {this.synced, this.total, required this.status, required this.label});

  D2SyncStatus increment() {
    if (synced != null) {
      synced = synced! + 1;
    }
    return this;
  }

  double get progress {
    if (total != null && total == 0) {
      return 0;
    }
    double progress = ((synced ?? 0) / total!);
    return clampDouble(progress, 0, 1);
  }

  D2SyncStatus setTotal(int total) {
    this.total = total;
    synced = 0;
    return this;
  }

  D2SyncStatus.fromMap(Map<String, dynamic> json)
      : label = json["label"],
        synced = json["synced"],
        total = json["total"],
        status = D2SyncStatusEnum.values[json["status"]],
        subProcess = json["subProcess"] == null
            ? null
            : D2SyncStatus.fromMap(json["subProcess"]);

  Map<String, dynamic> toMap() {
    return {
      "label": label,
      "synced": synced,
      "total": total,
      "status": status.index,
      "subProcess": subProcess?.toMap()
    };
  }

  D2SyncStatus complete() {
    status = D2SyncStatusEnum.complete;
    return this;
  }

  D2SyncStatus updateStatus(D2SyncStatusEnum newStatus) {
    status = newStatus;
    return this;
  }
}
