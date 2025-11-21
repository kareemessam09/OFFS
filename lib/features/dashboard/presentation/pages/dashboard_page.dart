import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offs/config/routes/app_router.dart';
import 'package:offs/core/di/injection.dart';
import 'package:offs/features/sync/presentation/bloc/sync_status_bloc.dart';
import 'package:offs/features/sync/presentation/widgets/sync_status_indicator.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SyncStatusBloc>()..add(SubscribeToSyncStatus()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: const [SyncStatusIndicator()],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome to Offs'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.tasks);
                },
                child: const Text('Go to Tasks'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.inventory);
                },
                child: const Text('Go to Inventory'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
