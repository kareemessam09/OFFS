import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/core/errors/failures.dart';
import 'package:offs/features/inventory/domain/entities/inventory_item.dart';
import 'package:offs/features/inventory/domain/repositories/inventory_repository.dart';

@lazySingleton
class UpdateQuantity {
  final InventoryRepository _repository;

  UpdateQuantity(this._repository);

  Future<Either<Failure, InventoryItem>> call(int id, int newQuantity) async {
    return await _repository.updateQuantity(id, newQuantity);
  }
}
