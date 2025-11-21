import 'package:flutter/material.dart';
import 'package:offs/app.dart';
import 'package:offs/core/di/injection.dart';
import 'package:offs/core/services/sync_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // We need to configure dependencies in the background isolate
    configureDependencies();
    final syncService = getIt<SyncService>();
    try {
      await syncService.syncPendingItems();
      return Future.value(true);
    } catch (e) {
      debugPrint('Background sync failed: $e');
      return Future.value(false);
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();

  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true, // TODO: Set to false in production
  );

  await Workmanager().registerPeriodicTask(
    "sync-task",
    "syncPeriodicTask",
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
  );

  runApp(const OffsApp());
}
