/// Enumeration representing the synchronization status.
///
/// This enum has three possible values:
/// - [D2SyncStatusEnum.initialized] Indicates the synchronization process has been initialized.
/// - [D2SyncStatusEnum.syncing] Indicates the synchronization process is ongoing.
/// - [D2SyncStatusEnum.complete] Indicates the synchronization process is complete.
enum D2SyncStatusEnum { initialized, syncing, complete }

/// This class represents the synchronization status.
///
/// This class includes properties and methods to track and manage the progress of a synchronization process.
class D2SyncStatus {
  /// The label for the synchronization status.
  String label;

  /// The number of items that have been synced. Defaults to 0.
  int? synced = 0;

  /// The total number of items to be synced.
  int? total;

  /// The current status of the synchronization process.
  D2SyncStatusEnum status;

  /// The sub-process of the current synchronization process.
  D2SyncStatus? subProcess;

  /// Constructs a [D2SyncStatus] instance with the specified parameters.
  ///
  /// - [label] is the label for the synchronization status.
  /// - [status] is the current status of the synchronization process.
  /// - [synced] is the number of items that have been synced.
  /// - [total] is the total number of items to be synced.
  D2SyncStatus(
      {this.synced, this.total, required this.status, required this.label});

  /// Increments the number of synced items by 1.
  ///
  /// If [synced] is null, it does nothing.
  ///
  /// Returns the updated [D2SyncStatus] instance.
  D2SyncStatus increment() {
    if (synced != null) {
      synced = synced! + 1;
    }
    return this;
  }

  /// Sets the total number of items to be synced.
  ///
  /// - [total] is the total number of items to be synced.
  ///
  /// Returns the updated [D2SyncStatus] instance with the synced count reset to 0.
  D2SyncStatus setTotal(int total) {
    this.total = total;
    synced = 0;
    return this;
  }

  /// Marks the synchronization process as complete.
  ///
  /// Sets the status to [D2SyncStatusEnum.complete].
  ///
  /// Returns the updated [D2SyncStatus] instance.
  D2SyncStatus complete() {
    status = D2SyncStatusEnum.complete;
    return this;
  }

  /// Updates the status of the synchronization process.
  ///
  /// - [newStatus] is the new status of the synchronization process.
  ///
  /// Returns the updated [D2SyncStatus] instance.
  D2SyncStatus updateStatus(D2SyncStatusEnum newStatus) {
    status = newStatus;
    return this;
  }
}
