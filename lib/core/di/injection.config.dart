// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/inventory/data/datasources/inventory_local_datasource.dart'
    as _i716;
import '../../features/inventory/data/datasources/inventory_remote_datasource.dart'
    as _i103;
import '../../features/inventory/data/repositories/inventory_repository_impl.dart'
    as _i572;
import '../../features/inventory/domain/repositories/inventory_repository.dart'
    as _i422;
import '../../features/inventory/domain/usecases/get_inventory.dart' as _i313;
import '../../features/inventory/domain/usecases/get_inventory_item_by_sku.dart'
    as _i885;
import '../../features/inventory/domain/usecases/search_inventory.dart'
    as _i869;
import '../../features/inventory/domain/usecases/update_quantity.dart' as _i242;
import '../../features/inventory/presentation/bloc/inventory_bloc.dart'
    as _i690;
import '../../features/tasks/data/datasources/task_local_datasource.dart'
    as _i123;
import '../../features/tasks/data/datasources/task_remote_datasource.dart'
    as _i25;
import '../../features/tasks/data/repositories/task_repository_impl.dart'
    as _i20;
import '../../features/tasks/domain/repositories/task_repository.dart' as _i148;
import '../../features/tasks/domain/usecases/create_task.dart' as _i602;
import '../../features/tasks/domain/usecases/delete_task.dart' as _i840;
import '../../features/tasks/domain/usecases/get_tasks.dart' as _i517;
import '../../features/tasks/domain/usecases/update_task.dart' as _i739;
import '../../features/tasks/presentation/bloc/task_bloc.dart' as _i841;
import '../database/daos/inventory_dao.dart' as _i773;
import '../database/daos/sync_queue_dao.dart' as _i428;
import '../database/daos/tasks_dao.dart' as _i897;
import '../database/database.dart' as _i660;
import '../network/network_info.dart' as _i932;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i660.AppDatabase>(() => registerModule.appDatabase);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i103.InventoryRemoteDataSource>(
      () => _i103.InventoryRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i25.TaskRemoteDataSource>(
      () => _i25.TaskRemoteDataSourceImpl(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i932.NetworkInfo>(
      () => _i932.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i897.TasksDao>(
      () => _i897.TasksDao(gh<_i660.AppDatabase>()),
    );
    gh.lazySingleton<_i428.SyncQueueDao>(
      () => _i428.SyncQueueDao(gh<_i660.AppDatabase>()),
    );
    gh.lazySingleton<_i773.InventoryDao>(
      () => _i773.InventoryDao(gh<_i660.AppDatabase>()),
    );
    gh.lazySingleton<_i716.InventoryLocalDataSource>(
      () => _i716.InventoryLocalDataSourceImpl(gh<_i773.InventoryDao>()),
    );
    gh.lazySingleton<_i123.TaskLocalDataSource>(
      () => _i123.TaskLocalDataSourceImpl(gh<_i897.TasksDao>()),
    );
    gh.lazySingleton<_i148.TaskRepository>(
      () => _i20.TaskRepositoryImpl(
        gh<_i123.TaskLocalDataSource>(),
        gh<_i428.SyncQueueDao>(),
      ),
    );
    gh.lazySingleton<_i422.InventoryRepository>(
      () => _i572.InventoryRepositoryImpl(
        gh<_i716.InventoryLocalDataSource>(),
        gh<_i103.InventoryRemoteDataSource>(),
        gh<_i932.NetworkInfo>(),
        gh<_i428.SyncQueueDao>(),
      ),
    );
    gh.lazySingleton<_i840.DeleteTask>(
      () => _i840.DeleteTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i602.CreateTask>(
      () => _i602.CreateTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i517.GetTasks>(
      () => _i517.GetTasks(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i739.UpdateTask>(
      () => _i739.UpdateTask(gh<_i148.TaskRepository>()),
    );
    gh.lazySingleton<_i242.UpdateQuantity>(
      () => _i242.UpdateQuantity(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i885.GetInventoryItemBySku>(
      () => _i885.GetInventoryItemBySku(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i869.SearchInventory>(
      () => _i869.SearchInventory(gh<_i422.InventoryRepository>()),
    );
    gh.lazySingleton<_i313.GetInventory>(
      () => _i313.GetInventory(gh<_i422.InventoryRepository>()),
    );
    gh.factory<_i690.InventoryBloc>(
      () => _i690.InventoryBloc(
        gh<_i313.GetInventory>(),
        gh<_i869.SearchInventory>(),
        gh<_i242.UpdateQuantity>(),
      ),
    );
    gh.factory<_i841.TaskBloc>(
      () => _i841.TaskBloc(
        gh<_i517.GetTasks>(),
        gh<_i602.CreateTask>(),
        gh<_i739.UpdateTask>(),
        gh<_i840.DeleteTask>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}
