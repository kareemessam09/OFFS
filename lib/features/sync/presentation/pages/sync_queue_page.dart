import 'package:flutter/material.dart';
import 'package:offs/core/database/daos/sync_queue_dao.dart';
import 'package:offs/core/database/database.dart';
import 'package:offs/core/di/injection.dart';
import 'package:offs/core/services/sync_service.dart';

class SyncQueuePage extends StatelessWidget {
  const SyncQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final dao = getIt<SyncQueueDao>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Queue'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              getIt<SyncService>().syncPendingItems();
            },
          ),
        ],
      ),
      body: StreamBuilder<List<SyncQueueData>>(
        stream: dao.watchPendingSyncItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data!;

          if (items.isEmpty) {
            return const Center(child: Text('No pending items'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(
                  '${item.operation.toUpperCase()} ${item.entityType}',
                ),
                subtitle: Text('ID: ${item.entityId} | Status: ${item.status}'),
                trailing: item.status == 'conflict'
                    ? ElevatedButton(
                        onPressed: () {
                          _showConflictDialog(context, item);
                        },
                        child: const Text('Resolve'),
                      )
                    : const Icon(Icons.hourglass_empty),
              );
            },
          );
        },
      ),
    );
  }

  void _showConflictDialog(BuildContext context, SyncQueueData item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resolve Conflict'),
        content: const Text(
          'The server has a newer version of this item. What would you like to do?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Discard local changes
              getIt<SyncQueueDao>().deleteSyncItem(item.id);
              Navigator.pop(context);
            },
            child: const Text('Discard Local'),
          ),
          TextButton(
            onPressed: () {
              // Force overwrite (retry)
              getIt<SyncQueueDao>().updateSyncStatus(item.id, 'pending');
              getIt<SyncService>().syncPendingItems();
              Navigator.pop(context);
            },
            child: const Text('Force Overwrite'),
          ),
        ],
      ),
    );
  }
}
