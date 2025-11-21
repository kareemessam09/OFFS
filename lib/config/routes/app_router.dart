import 'package:flutter/material.dart';
import 'package:offs/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:offs/features/inventory/presentation/pages/inventory_page.dart';
import 'package:offs/features/sync/presentation/pages/sync_queue_page.dart';
import 'package:offs/features/tasks/presentation/pages/task_list_page.dart';

class AppRouter {
  static const String dashboard = '/';
  static const String tasks = '/tasks';
  static const String inventory = '/inventory';
  static const String syncQueue = '/sync-queue';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case tasks:
        return MaterialPageRoute(builder: (_) => const TaskListPage());
      case inventory:
        return MaterialPageRoute(builder: (_) => const InventoryPage());
      case syncQueue:
        return MaterialPageRoute(builder: (_) => const SyncQueuePage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
