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
    // TODO: Implement API call
    return [];
  }

  @override
  Future<InventoryItemModel> getInventoryItem(int id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<InventoryItemModel> updateQuantity(int id, int quantity) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
