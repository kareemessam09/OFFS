import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/database/database.dart';
import 'package:offs/core/database/tables/inventory_table.dart';

part 'inventory_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [InventoryItems])
class InventoryDao extends DatabaseAccessor<AppDatabase> with _$InventoryDaoMixin {
  InventoryDao(super.db);

  Future<List<InventoryItemData>> getAllInventory() => select(inventoryItems).get();

  Future<InventoryItemData> getInventoryById(int id) =>
      (select(inventoryItems)..where((t) => t.id.equals(id))).getSingle();

  Future<InventoryItemData?> getInventoryBySku(String sku) =>
      (select(inventoryItems)..where((t) => t.sku.equals(sku))).getSingleOrNull();

  Future<List<InventoryItemData>> searchInventory(String query) =>
      (select(inventoryItems)..where((t) => t.name.contains(query) | t.sku.contains(query))).get();

  Future<int> insertInventoryItem(InventoryItemsCompanion item) =>
      into(inventoryItems).insert(item);

  Future<bool> updateInventoryItem(InventoryItemsCompanion item) =>
      update(inventoryItems).replace(item);
}
