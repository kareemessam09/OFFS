import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offs/config/routes/app_router.dart';
import 'package:offs/features/sync/presentation/bloc/sync_status_bloc.dart';

class SyncStatusIndicator extends StatelessWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SyncStatusBloc, SyncStatusState>(
      builder: (context, state) {
        if (state.status == SyncStatus.syncing) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        }

        if (state.pendingCount > 0) {
          return IconButton(
            icon: Badge(
              label: Text('${state.pendingCount}'),
              child: const Icon(Icons.cloud_upload),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRouter.syncQueue);
            },
            tooltip: 'Sync pending items',
          );
        }

        return IconButton(
          icon: const Icon(Icons.cloud_done),
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.syncQueue);
          },
          tooltip: 'All synced',
        );
      },
    );
  }
}
