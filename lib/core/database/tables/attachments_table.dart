import 'package:drift/drift.dart';

class Attachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get taskId => integer().nullable()();
  TextColumn get filePath => text()();
  TextColumn get fileType => text()(); // 'image', 'document'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
