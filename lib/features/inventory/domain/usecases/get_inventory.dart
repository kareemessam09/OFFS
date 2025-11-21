import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/inventory/domain/entities/inventory_item.dart';
import 'package:offs/features/inventory/domain/repositories/inventory_repository.dart';

@lazySingleton
class GetInventory {
  final InventoryRepository _repository;

  GetInventory(this._repository);

  Future<Either<Failure, List<InventoryItem>>> call() async {
    return await _repository.getInventory();
  }
}
