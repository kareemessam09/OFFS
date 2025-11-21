import 'package:injectable/injectable.dart';
import 'package:offs/core/database/daos/inventory_dao.dart';
import 'package:offs/core/database/database.dart';
import 'package:offs/features/inventory/data/models/inventory_item_model.dart';
import 'package:drift/drift.dart';

abstract class InventoryLocalDataSource {
  Future<List<InventoryItemModel>> getInventory();
  Future<InventoryItemModel?> getInventoryItem(int id);
  Future<InventoryItemModel?> getInventoryItemBySku(String sku);
  Future<List<InventoryItemModel>> searchInventory(String query);
  Future<int> createInventoryItem(InventoryItemModel item);
  Future<bool> updateInventoryItem(InventoryItemModel item);
  Future<void> cacheInventory(List<InventoryItemModel> items);
}

@LazySingleton(as: InventoryLocalDataSource)
class InventoryLocalDataSourceImpl implements InventoryLocalDataSource {
  final InventoryDao _inventoryDao;

  InventoryLocalDataSourceImpl(this._inventoryDao);

  @override
  Future<List<InventoryItemModel>> getInventory() async {
    final items = await _inventoryDao.getAllInventory();
    return items.map((e) => InventoryItemModel.fromDb(e)).toList();
  }

  @override
  Future<InventoryItemModel?> getInventoryItem(int id) async {
    try {
      final item = await _inventoryDao.getInventoryById(id);
      return InventoryItemModel.fromDb(item);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<InventoryItemModel?> getInventoryItemBySku(String sku) async {
    final item = await _inventoryDao.getInventoryBySku(sku);
    return item != null ? InventoryItemModel.fromDb(item) : null;
  }

  @override
  Future<List<InventoryItemModel>> searchInventory(String query) async {
    final items = await _inventoryDao.searchInventory(query);
    return items.map((e) => InventoryItemModel.fromDb(e)).toList();
  }

  @override
  Future<int> createInventoryItem(InventoryItemModel item) {
    return _inventoryDao.insertInventoryItem(
      InventoryItemsCompanion(
        name: Value(item.name),
        sku: Value(item.sku),
        quantity: Value(item.quantity),
        location: Value(item.location),
        lastUpdated: Value(item.lastUpdated),
      ),
    );
  }

  @override
  Future<bool> updateInventoryItem(InventoryItemModel item) {
    return _inventoryDao.updateInventoryItem(
      InventoryItemsCompanion(
        id: Value(item.id),
        name: Value(item.name),
        sku: Value(item.sku),
        quantity: Value(item.quantity),
        location: Value(item.location),
        lastUpdated: Value(item.lastUpdated),
      ),
    );
  }

  @override
  Future<void> cacheInventory(List<InventoryItemModel> items) async {
    // This should probably be a transaction
    for (var item in items) {
      final existing = await _inventoryDao.getInventoryBySku(item.sku);
      if (existing != null) {
        await _inventoryDao.updateInventoryItem(
          InventoryItemsCompanion(
            id: Value(existing.id),
            name: Value(item.name),
            sku: Value(item.sku),
            quantity: Value(item.quantity),
            location: Value(item.location),
            lastUpdated: Value(item.lastUpdated),
          ),
        );
      } else {
        await _inventoryDao.insertInventoryItem(
          InventoryItemsCompanion(
            name: Value(item.name),
            sku: Value(item.sku),
            quantity: Value(item.quantity),
            location: Value(item.location),
            lastUpdated: Value(item.lastUpdated),
          ),
        );
      }
    }
  }
}
