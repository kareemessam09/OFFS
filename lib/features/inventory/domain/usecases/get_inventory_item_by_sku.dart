import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/inventory/domain/entities/inventory_item.dart';
import 'package:offs/features/inventory/domain/repositories/inventory_repository.dart';

@lazySingleton
class GetInventoryItemBySku {
  final InventoryRepository _repository;

  GetInventoryItemBySku(this._repository);

  Future<Either<Failure, InventoryItem>> call(String sku) async {
    return await _repository.getInventoryItemBySku(sku);
  }
}
