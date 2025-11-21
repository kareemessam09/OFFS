part of 'sync_status_bloc.dart';

abstract class SyncStatusEvent extends Equatable {
  const SyncStatusEvent();

  @override
  List<Object> get props => [];
}

class SubscribeToSyncStatus extends SyncStatusEvent {}

class TriggerManualSync extends SyncStatusEvent {}

class _SyncStatusUpdated extends SyncStatusEvent {
  final int pendingCount;

  const _SyncStatusUpdated(this.pendingCount);

  @override
  List<Object> get props => [pendingCount];
}
