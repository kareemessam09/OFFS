import 'package:fpdart/fpdart.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/inventory/domain/entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<Either<Failure, List<InventoryItem>>> getInventory();
  Future<Either<Failure, InventoryItem>> getInventoryItem(int id);
  Future<Either<Failure, InventoryItem>> updateQuantity(
    int id,
    int newQuantity,
  );
  Future<Either<Failure, List<InventoryItem>>> searchInventory(String query);
  Future<Either<Failure, InventoryItem>> getInventoryItemBySku(String sku);
}
