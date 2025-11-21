part of 'inventory_bloc.dart';

enum InventoryStatus { initial, loading, success, failure }

class InventoryState extends Equatable {
  final InventoryStatus status;
  final List<InventoryItem> items;
  final String? errorMessage;

  const InventoryState({
    this.status = InventoryStatus.initial,
    this.items = const [],
    this.errorMessage,
  });

  InventoryState copyWith({
    InventoryStatus? status,
    List<InventoryItem>? items,
    String? errorMessage,
  }) {
    return InventoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
