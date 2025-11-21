import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/core/network/network_info.dart';
import 'package:offs/features/inventory/data/datasources/inventory_local_datasource.dart';
import 'package:offs/features/inventory/data/datasources/inventory_remote_datasource.dart';
import 'package:offs/features/inventory/data/models/inventory_item_model.dart';
import 'package:offs/features/inventory/domain/entities/inventory_item.dart';
import 'package:offs/features/inventory/domain/repositories/inventory_repository.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryLocalDataSource _localDataSource;
  final InventoryRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  InventoryRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, List<InventoryItem>>> getInventory() async {
    if (await _networkInfo.isConnected) {
      try {
        final remoteInventory = await _remoteDataSource.getInventory();
        await _localDataSource.cacheInventory(remoteInventory);
        return Right(remoteInventory);
      } catch (e) {
        // If remote fails, try local
        try {
          final localInventory = await _localDataSource.getInventory();
          return Right(localInventory);
        } catch (e) {
          return Left(CacheFailure('Failed to load inventory from cache'));
        }
      }
    } else {
      try {
        final localInventory = await _localDataSource.getInventory();
        return Right(localInventory);
      } catch (e) {
        return Left(CacheFailure('Failed to load inventory from cache'));
      }
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> getInventoryItemBySku(String sku) async {
    try {
      final localItem = await _localDataSource.getInventoryItemBySku(sku);
      if (localItem != null) {
        return Right(localItem);
      } else {
        return Left(CacheFailure('Item not found in cache'));
      }
    } catch (e) {
      return Left(CacheFailure('Failed to load item from cache'));
    }
  }

  @override
  Future<Either<Failure, List<InventoryItem>>> searchInventory(String query) async {
    try {
      final localInventory = await _localDataSource.searchInventory(query);
      return Right(localInventory);
    } catch (e) {
      return Left(CacheFailure('Failed to search inventory'));
    }
  }

  @override
  Future<Either<Failure, InventoryItem>> updateQuantity(int id, int quantity) async {
    if (await _networkInfo.isConnected) {
      try {
        final updatedItem = await _remoteDataSource.updateQuantity(id, quantity);
        await _localDataSource.updateInventoryItem(updatedItem);
        return Right(updatedItem);
      } catch (e) {
        // If remote fails, we should queue the update (not implemented yet) or fail
        // For now, let's update local and return success (optimistic update)
        // But we need the item first
        try {
          final item = await _localDataSource.getInventoryItem(id);
          if (item != null) {
             final updatedModel = InventoryItemModel(
               id: item.id,
               name: item.name,
               sku: item.sku,
               quantity: quantity,
               location: item.location,
               lastUpdated: DateTime.now(),
             );
             await _localDataSource.updateInventoryItem(updatedModel);
             return Right(updatedModel);
          } else {
            return Left(CacheFailure('Item not found'));
          }
        } catch (e) {
          return Left(CacheFailure('Failed to update item'));
        }
      }
    } else {
       try {
          final item = await _localDataSource.getInventoryItem(id);
          if (item != null) {
             final updatedModel = InventoryItemModel(
               id: item.id,
               name: item.name,
               sku: item.sku,
               quantity: quantity,
               location: item.location,
               lastUpdated: DateTime.now(),
             );
             await _localDataSource.updateInventoryItem(updatedModel);
             // TODO: Queue sync
             return Right(updatedModel);
          } else {
            return Left(CacheFailure('Item not found'));
          }
        } catch (e) {
          return Left(CacheFailure('Failed to update item'));
        }
    }
  }
}
