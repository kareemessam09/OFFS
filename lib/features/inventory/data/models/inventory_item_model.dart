import 'package:offs/features/inventory/domain/entities/inventory_item.dart';
import 'package:offs/core/database/database.dart';

class InventoryItemModel extends InventoryItem {
  const InventoryItemModel({
    required super.id,
    required super.name,
    required super.sku,
    required super.quantity,
    super.location,
    required super.lastUpdated,
  });

  factory InventoryItemModel.fromJson(Map<String, dynamic> json) {
    return InventoryItemModel(
      id: json['id'] as int,
      name: json['name'] as String,
      sku: json['sku'] as String,
      quantity: json['quantity'] as int,
      location: json['location'] as String?,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'quantity': quantity,
      'location': location,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  factory InventoryItemModel.fromEntity(InventoryItem entity) {
    return InventoryItemModel(
      id: entity.id,
      name: entity.name,
      sku: entity.sku,
      quantity: entity.quantity,
      location: entity.location,
      lastUpdated: entity.lastUpdated,
    );
  }

  factory InventoryItemModel.fromDb(InventoryItemData dbEntity) {
    return InventoryItemModel(
      id: dbEntity.id,
      name: dbEntity.name,
      sku: dbEntity.sku,
      quantity: dbEntity.quantity,
      location: dbEntity.location,
      lastUpdated: dbEntity.lastUpdated,
    );
  }

  InventoryItemData toDb() {
    return InventoryItemData(
      id: id,
      name: name,
      sku: sku,
      quantity: quantity,
      location: location,
      lastUpdated: lastUpdated,
    );
  }
}
