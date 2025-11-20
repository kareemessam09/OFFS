import 'package:equatable/equatable.dart';
import 'package:offs/core/utils/enums.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final String? description;
  final TaskStatus status;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    status,
    dueDate,
    createdAt,
    updatedAt,
  ];
}
