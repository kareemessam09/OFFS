import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/database/database.dart';
import 'package:offs/core/database/tables/sync_queue_table.dart';

part 'sync_queue_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Future<int> addToQueue(SyncQueueCompanion entry) =>
      into(syncQueue).insert(entry);

  Future<List<SyncQueueData>> getPendingSyncItems() =>
      (select(syncQueue)..where((t) => t.status.equals('pending'))).get();

  Future<void> updateSyncStatus(int id, String status) =>
      (update(syncQueue)..where((t) => t.id.equals(id))).write(
        SyncQueueCompanion(status: Value(status)),
      );

  Future<void> deleteSyncItem(int id) =>
      (delete(syncQueue)..where((t) => t.id.equals(id))).go();
}
