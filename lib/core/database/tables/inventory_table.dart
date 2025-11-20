import 'package:drift/drift.dart';

class InventoryItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get sku => text().unique()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  TextColumn get location => text().nullable()();
  DateTimeColumn get lastUpdated =>
      dateTime().withDefault(currentDateAndTime)();
}
