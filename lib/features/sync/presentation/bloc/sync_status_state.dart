part of 'sync_status_bloc.dart';

enum SyncStatus { initial, syncing, synced, error }

class SyncStatusState extends Equatable {
  final SyncStatus status;
  final int pendingCount;
  final String? errorMessage;

  const SyncStatusState({
    this.status = SyncStatus.initial,
    this.pendingCount = 0,
    this.errorMessage,
  });

  SyncStatusState copyWith({
    SyncStatus? status,
    int? pendingCount,
    String? errorMessage,
  }) {
    return SyncStatusState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, pendingCount, errorMessage];
}
