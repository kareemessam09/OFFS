part of 'inventory_bloc.dart';

abstract class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object> get props => [];
}

class LoadInventory extends InventoryEvent {}

class SearchInventoryEvent extends InventoryEvent {
  final String query;

  const SearchInventoryEvent(this.query);

  @override
  List<Object> get props => [query];
}

class UpdateInventoryQuantity extends InventoryEvent {
  final int id;
  final int quantity;

  const UpdateInventoryQuantity(this.id, this.quantity);

  @override
  List<Object> get props => [id, quantity];
}
