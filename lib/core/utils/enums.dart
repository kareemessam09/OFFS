enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled;

  String toShortString() => toString().split('.').last;

  static TaskStatus fromString(String status) {
    return TaskStatus.values.firstWhere(
      (e) => e.toString().split('.').last == status,
      orElse: () => TaskStatus.pending,
    );
  }
}
