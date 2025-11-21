import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:offs/features/inventory/domain/entities/inventory_item.dart';
import 'package:offs/features/inventory/domain/usecases/get_inventory.dart';
import 'package:offs/features/inventory/domain/usecases/search_inventory.dart';
import 'package:offs/features/inventory/domain/usecases/update_quantity.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

@injectable
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetInventory _getInventory;
  final SearchInventory _searchInventory;
  final UpdateQuantity _updateQuantity;

  InventoryBloc(this._getInventory, this._searchInventory, this._updateQuantity)
    : super(const InventoryState()) {
    on<LoadInventory>(_onLoadInventory);
    on<SearchInventoryEvent>(_onSearchInventory);
    on<UpdateInventoryQuantity>(_onUpdateQuantity);
  }

  Future<void> _onLoadInventory(
    LoadInventory event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: InventoryStatus.loading));
    final result = await _getInventory();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InventoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) =>
          emit(state.copyWith(status: InventoryStatus.success, items: items)),
    );
  }

  Future<void> _onSearchInventory(
    SearchInventoryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(status: InventoryStatus.loading));
    final result = await _searchInventory(event.query);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: InventoryStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (items) =>
          emit(state.copyWith(status: InventoryStatus.success, items: items)),
    );
  }

  Future<void> _onUpdateQuantity(
    UpdateInventoryQuantity event,
    Emitter<InventoryState> emit,
  ) async {
    final result = await _updateQuantity(event.id, event.quantity);

    result.fold(
      (failure) => emit(state.copyWith(errorMessage: failure.message)),
      (updatedItem) {
        final updatedItems = state.items.map((item) {
          return item.id == updatedItem.id ? updatedItem : item;
        }).toList();
        emit(state.copyWith(items: updatedItems));
      },
    );
  }
}
