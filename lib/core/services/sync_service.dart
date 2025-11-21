import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/database/daos/sync_queue_dao.dart';
import 'package:offs/core/database/database.dart';
import 'package:offs/core/network/network_info.dart';
import 'package:offs/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:offs/features/inventory/data/models/inventory_item_model.dart';
import 'package:offs/features/tasks/data/datasources/task_remote_datasource.dart';
import 'package:offs/features/tasks/data/models/task_model.dart';

@lazySingleton
class SyncService {
  final SyncQueueDao _syncQueueDao;
  final TaskRemoteDataSource _taskRemoteDataSource;
  final InventoryRemoteDataSource _inventoryRemoteDataSource;
  final NetworkInfo _networkInfo;

  SyncService(
    this._syncQueueDao,
    this._taskRemoteDataSource,
    this._inventoryRemoteDataSource,
    this._networkInfo,
  );

  Future<void> syncPendingItems() async {
    if (!await _networkInfo.isConnected) {
      return;
    }

    final pendingItems = await _syncQueueDao.getPendingSyncItems();

    for (final item in pendingItems) {
      try {
        await _processItem(item);
        await _syncQueueDao.updateSyncStatus(item.id, 'completed');
      } catch (e) {
        // Log error or increment retry count
        debugPrint('Error syncing item ${item.id}: $e');
      }
    }
  }

  Future<void> _processItem(SyncQueueData item) async {
    final payload = jsonDecode(item.payload) as Map<String, dynamic>;

    if (item.entityType == 'task') {
      await _processTaskItem(item.operation, payload, item.entityId);
    } else if (item.entityType == 'inventory') {
      await _processInventoryItem(item.operation, payload, item.entityId);
    }
  }

  Future<void> _processTaskItem(
    String operation,
    Map<String, dynamic> payload,
    int entityId,
  ) async {
    switch (operation) {
      case 'create':
        final task = TaskModel.fromJson(payload);
        await _taskRemoteDataSource.createTask(task);
        break;
      case 'update':
        final task = TaskModel.fromJson(payload);
        await _taskRemoteDataSource.updateTask(task);
        break;
      case 'delete':
        await _taskRemoteDataSource.deleteTask(entityId);
        break;
    }
  }

  Future<void> _processInventoryItem(
    String operation,
    Map<String, dynamic> payload,
    int entityId,
  ) async {
    switch (operation) {
      case 'update':
        // For inventory, we currently only support quantity updates via sync
        // But the payload is the full model.
        final item = InventoryItemModel.fromJson(payload);
        await _inventoryRemoteDataSource.updateQuantity(item.id, item.quantity);
        break;
    }
  }
}
