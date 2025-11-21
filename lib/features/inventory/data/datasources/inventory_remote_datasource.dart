import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/features/inventory/data/models/inventory_item_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<InventoryItemModel>> getInventory();
  Future<InventoryItemModel> getInventoryItem(int id);
  Future<InventoryItemModel> updateQuantity(int id, int quantity);
}

@LazySingleton(as: InventoryRemoteDataSource)
class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final Dio _dio;

  InventoryRemoteDataSourceImpl(this._dio);

  @override
  Future<List<InventoryItemModel>> getInventory() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      InventoryItemModel(
        id: 201,
        name: 'Remote Item A',
        sku: 'REM-001',
        quantity: 50,
        location: 'Warehouse A',
        lastUpdated: DateTime.now(),
      ),
      InventoryItemModel(
        id: 202,
        name: 'Remote Item B',
        sku: 'REM-002',
        quantity: 20,
        location: 'Warehouse B',
        lastUpdated: DateTime.now(),
      ),
    ];
  }

  @override
  Future<InventoryItemModel> getInventoryItem(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return InventoryItemModel(
      id: id,
      name: 'Remote Item $id',
      sku: 'REM-$id',
      quantity: 10,
      location: 'Warehouse A',
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<InventoryItemModel> updateQuantity(int id, int quantity) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return InventoryItemModel(
      id: id,
      name: 'Remote Item $id',
      sku: 'REM-$id',
      quantity: quantity,
      location: 'Warehouse A',
      lastUpdated: DateTime.now(),
    );
  }
}
