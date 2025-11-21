import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/database/daos/sync_queue_dao.dart';
import 'package:offs/core/services/sync_service.dart';

part 'sync_status_event.dart';
part 'sync_status_state.dart';

@injectable
class SyncStatusBloc extends Bloc<SyncStatusEvent, SyncStatusState> {
  final SyncQueueDao _syncQueueDao;
  final SyncService _syncService;
  StreamSubscription<int>? _subscription;

  SyncStatusBloc(this._syncQueueDao, this._syncService)
    : super(const SyncStatusState()) {
    on<SubscribeToSyncStatus>(_onSubscribeToSyncStatus);
    on<_SyncStatusUpdated>(_onSyncStatusUpdated);
    on<TriggerManualSync>(_onTriggerManualSync);
  }

  Future<void> _onSubscribeToSyncStatus(
    SubscribeToSyncStatus event,
    Emitter<SyncStatusState> emit,
  ) async {
    await _subscription?.cancel();
    _subscription = _syncQueueDao.watchPendingItemsCount().listen((count) {
      add(_SyncStatusUpdated(count));
    });
  }

  void _onSyncStatusUpdated(
    _SyncStatusUpdated event,
    Emitter<SyncStatusState> emit,
  ) {
    emit(state.copyWith(pendingCount: event.pendingCount));
  }

  Future<void> _onTriggerManualSync(
    TriggerManualSync event,
    Emitter<SyncStatusState> emit,
  ) async {
    emit(state.copyWith(status: SyncStatus.syncing));
    try {
      await _syncService.syncPendingItems();
      emit(state.copyWith(status: SyncStatus.synced));
      // Reset status to initial after a delay so the "synced" icon doesn't stay forever?
      // Or just keep it.
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(status: SyncStatus.initial));
    } catch (e) {
      emit(
        state.copyWith(status: SyncStatus.error, errorMessage: e.toString()),
      );
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
