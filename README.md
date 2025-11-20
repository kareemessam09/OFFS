# offs

# Offline-First Field Service App - Complete Technical Specification

## Executive Summary

Build a production-ready mobile application for field service workers (delivery drivers, warehouse staff, technicians) who operate in areas with unreliable internet connectivity. The app must function completely offline, with intelligent background synchronization when connectivity is restored.

---

## 1. PROJECT OVERVIEW

### 1.1 Problem Statement
Field workers need to:
- Access task lists and inventory data without internet
- Update inventory quantities and task statuses in real-time
- Capture photos and scan barcodes without connectivity
- Never lose data due to connection issues
- Automatically sync all changes when back online

### 1.2 Solution Architecture
A Flutter mobile application with:
- **Local-First Architecture**: SQLite (Drift) as the single source of truth
- **Offline-First Design**: All features work without internet
- **Background Sync**: WorkManager handles automatic synchronization
- **Conflict Resolution**: Intelligent handling of data conflicts
- **Native Integration**: Android platform channels for performance-critical features

### 1.3 Success Criteria
- App works 100% offline for all core features
- Sync success rate > 98%
- No data loss in offline scenarios
- Conflicts resolved automatically or presented to user clearly
- Average sync time < 5 seconds for typical workload

---

## 2. TECHNICAL ARCHITECTURE

### 2.1 Technology Stack

```yaml
Flutter SDK: ^3.16.0
Dart: ^3.2.0

Core Dependencies:
  # State Management
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  bloc_concurrency: ^0.2.2
  
  # Local Database
  drift: ^2.13.0
  sqlite3_flutter_libs: ^0.5.0
  path_provider: ^2.1.1
  path: ^1.8.3
  
  # Networking
  dio: ^5.3.3
  connectivity_plus: ^5.0.1
  pretty_dio_logger: ^1.3.1
  
  # Background Processing
  workmanager: ^0.5.1
  
  # Native Features
  permission_handler: ^11.0.1
  image_picker: ^1.0.4
  url_launcher: ^6.2.1
  
  # Utilities
  intl: ^0.18.1
  uuid: ^4.1.0
  logger: ^2.0.2
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1
  get_it: ^7.6.4
  injectable: ^2.3.2

Dev Dependencies:
  drift_dev: ^2.13.0
  build_runner: ^2.4.6
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  mockito: ^5.4.2
  bloc_test: ^9.1.4
  flutter_test:
    sdk: flutter
```

### 2.2 Project Structure

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── database/
│   │   ├── database.dart                  # Drift database configuration
│   │   ├── tables/
│   │   │   ├── tasks_table.dart
│   │   │   ├── inventory_table.dart
│   │   │   ├── sync_queue_table.dart
│   │   │   └── attachments_table.dart
│   │   └── daos/
│   │       ├── tasks_dao.dart
│   │       ├── inventory_dao.dart
│   │       └── sync_queue_dao.dart
│   ├── network/
│   │   ├── api_client.dart               # Dio configuration
│   │   ├── api_endpoints.dart
│   │   ├── api_interceptors.dart
│   │   └── api_error_handler.dart
│   ├── platform/
│   │   ├── barcode_scanner_channel.dart
│   │   ├── navigation_channel.dart
│   │   └── camera_channel.dart
│   ├── services/
│   │   ├── connectivity_service.dart
│   │   ├── sync_service.dart
│   │   ├── storage_service.dart
│   │   └── notification_service.dart
│   ├── di/
│   │   └── injection.dart                # Dependency injection setup
│   ├── utils/
│   │   ├── constants.dart
│   │   ├── enums.dart
│   │   ├── extensions.dart
│   │   └── helpers.dart
│   └── errors/
│       ├── failures.dart
│       └── exceptions.dart
├── features/
│   ├── tasks/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── task_model.dart
│   │   │   │   └── task_model.g.dart
│   │   │   ├── repositories/
│   │   │   │   └── task_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── task_local_datasource.dart
│   │   │       └── task_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── task.dart
│   │   │   ├── repositories/
│   │   │   │   └── task_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_tasks.dart
│   │   │       ├── create_task.dart
│   │   │       ├── update_task_status.dart
│   │   │       └── delete_task.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── task_bloc.dart
│   │       │   ├── task_event.dart
│   │       │   └── task_state.dart
│   │       ├── pages/
│   │       │   ├── task_list_page.dart
│   │       │   └── task_detail_page.dart
│   │       └── widgets/
│   │           ├── task_card.dart
│   │           ├── task_filter_chip.dart
│   │           └── sync_indicator.dart
│   ├── inventory/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── inventory_item_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── inventory_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── inventory_local_datasource.dart
│   │   │       └── inventory_remote_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── inventory_item.dart
│   │   │   ├── repositories/
│   │   │   │   └── inventory_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_inventory.dart
│   │   │       ├── update_quantity.dart
│   │   │       ├── search_inventory.dart
│   │   │       └── scan_barcode.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── inventory_bloc.dart
│   │       │   ├── inventory_event.dart
│   │       │   └── inventory_state.dart
│   │       ├── pages/
│   │       │   ├── inventory_list_page.dart
│   │       │   └── inventory_detail_page.dart
│   │       └── widgets/
│   │           ├── inventory_card.dart
│   │           ├── quantity_adjuster.dart
│   │           └── barcode_button.dart
│   ├── sync/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   ├── sync_item_model.dart
│   │   │   │   └── conflict_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── sync_repository_impl.dart
│   │   │   └── datasources/
│   │   │       └── sync_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── sync_item.dart
│   │   │   │   └── conflict.dart
│   │   │   ├── repositories/
│   │   │   │   └── sync_repository.dart
│   │   │   └── usecases/
│   │   │       ├── sync_pending_changes.dart
│   │   │       ├── resolve_conflict.dart
│   │   │       └── check_sync_status.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── sync_bloc.dart
│   │       │   ├── sync_event.dart
│   │       │   └── sync_state.dart
│   │       ├── pages/
│   │       │   └── sync_status_page.dart
│   │       └── widgets/
│   │           ├── sync_progress_indicator.dart
│   │           └── conflict_resolution_dialog.dart
│   └── dashboard/
│       └── presentation/
│           ├── pages/
│           │   └── dashboard_page.dart
│           └── widgets/
│               ├── sync_status_card.dart
│               ├── task_summary_card.dart
│               └── quick_actions.dart
└── config/
    ├── routes/
    │   └── app_router.dart
    └── theme/
        ├── app_theme.dart
        └── app_colors.dart
```

### 2.3 Data Flow Architecture

```
User Action (UI)
    ↓
Bloc (Event Handler)
    ↓
Use Case (Business Logic)
    ↓
Repository (Abstraction)
    ↓
    ├─→ Local DataSource (Drift) ←─── Primary (Immediate Write)
    └─→ Remote DataSource (Dio)  ←─── Secondary (Queued)
         ↓
    Sync Queue (Background)
         ↓
    WorkManager (Scheduled Task)
         ↓
    Conflict Resolution
         ↓
    Update Local Database
         ↓
    Emit New State (UI Update)
```

---
