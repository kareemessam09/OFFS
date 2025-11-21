import 'package:equatable/equatable.dart';

class InventoryItem extends Equatable {
  final int id;
  final String name;
  final String sku;
  final int quantity;
  final String? location;
  final DateTime lastUpdated;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    this.location,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [id, name, sku, quantity, location, lastUpdated];
}
