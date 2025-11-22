# OFFS (Offline-First Flutter Sync)# offs



OFFS is a robust, production-ready mobile application built with Flutter that demonstrates a complete **Offline-First** architecture. It allows users to manage tasks and inventory seamlessly without an internet connection, intelligently syncing data with a backend server when connectivity is restored.# Offline-First Field Service App - Complete Technical Specification



## 🚀 Key Features## Executive Summary



*   **Offline-First Design**: All data is stored locally first using SQLite (Drift), ensuring the app is always fast and responsive regardless of network status.Build a production-ready mobile application for field service workers (delivery drivers, warehouse staff, technicians) who operate in areas with unreliable internet connectivity. The app must function completely offline, with intelligent background synchronization when connectivity is restored.

*   **Background Synchronization**: Uses `WorkManager` to reliably sync data in the background, even when the app is closed.

*   **Conflict Resolution**: Implements a robust strategy to handle data conflicts between local changes and server updates, with a UI for manual resolution when necessary.---

*   **Task Management**: Create, read, update, and delete tasks with due dates and status tracking.

*   **Inventory Management**: Track inventory items, update quantities, and search through the catalog with optimistic UI updates.## 1. PROJECT OVERVIEW

*   **Sync Status Visibility**: Real-time UI indicators showing sync status (Syncing, Synced, Error, Offline) and a dedicated queue page to view pending operations.

*   **Modern UI/UX**: Clean, responsive interface built with Material 3, supporting both Light and Dark modes.### 1.1 Problem Statement

Field workers need to:

## 🛠 Tech Stack- Access task lists and inventory data without internet

- Update inventory quantities and task statuses in real-time

*   **Framework**: [Flutter](https://flutter.dev/)- Capture photos and scan barcodes without connectivity

*   **Language**: [Dart](https://dart.dev/)- Never lose data due to connection issues

*   **State Management**: [Flutter Bloc](https://pub.dev/packages/flutter_bloc)- Automatically sync all changes when back online

*   **Local Database**: [Drift](https://pub.dev/packages/drift) (SQLite abstraction)

*   **Networking**: [Dio](https://pub.dev/packages/dio)### 1.2 Solution Architecture

*   **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it) & [Injectable](https://pub.dev/packages/injectable)A Flutter mobile application with:

*   **Background Tasks**: [WorkManager](https://pub.dev/packages/workmanager)- **Local-First Architecture**: SQLite (Drift) as the single source of truth

*   **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart)- **Offline-First Design**: All features work without internet

*   **Code Generation**: [Freezed](https://pub.dev/packages/freezed), [JsonSerializable](https://pub.dev/packages/json_serializable)- **Background Sync**: WorkManager handles automatic synchronization

- **Conflict Resolution**: Intelligent handling of data conflicts

## 🏗 Architecture- **Native Integration**: Android platform channels for performance-critical features



The project follows a **Clean Architecture** approach, separated by features:### 1.3 Success Criteria

- App works 100% offline for all core features

```- Sync success rate > 98%

lib/- No data loss in offline scenarios

├── config/             # App configuration (Routes, Theme)- Conflicts resolved automatically or presented to user clearly

├── core/               # Core utilities (Database, Network, DI, Services)- Average sync time < 5 seconds for typical workload

│   ├── database/       # Drift database setup and DAOs

│   ├── services/       # SyncService and background logic---

│   └── ...

├── features/           # Feature-based modules## 2. TECHNICAL ARCHITECTURE

│   ├── dashboard/      # Home screen

│   ├── inventory/      # Inventory management (Domain, Data, Presentation)### 2.1 Technology Stack

│   ├── sync/           # Sync status UI and logic

│   └── tasks/          # Task management (Domain, Data, Presentation)```yaml

├── app.dart            # App entry pointFlutter SDK: ^3.16.0

└── main.dart           # InitializationDart: ^3.2.0

```

Core Dependencies:

### Synchronization Strategy  # State Management

  flutter_bloc: ^8.1.3

1.  **Local Write**: User actions (create/update/delete) are immediately written to the local Drift database and added to a `SyncQueue` table.  equatable: ^2.0.5

2.  **Optimistic UI**: The UI updates immediately based on local data.  bloc_concurrency: ^0.2.2

3.  **Sync Process**:  

    *   A `SyncService` monitors network connectivity.  # Local Database

    *   When online, it processes the `SyncQueue` sequentially (FIFO).  drift: ^2.13.0

    *   Successful remote operations mark queue items as completed.  sqlite3_flutter_libs: ^0.5.0

    *   Failures trigger a retry mechanism or are marked as conflicts.  path_provider: ^2.1.1

4.  **Background Sync**: `WorkManager` triggers a periodic sync task (every 15 minutes) to ensure data consistency even if the user doesn't open the app.  path: ^1.8.3

  

## 🚦 Getting Started  # Networking

  dio: ^5.3.3

### Prerequisites  connectivity_plus: ^5.0.1

  pretty_dio_logger: ^1.3.1

*   Flutter SDK (Latest Stable)  

*   Android Studio / VS Code  # Background Processing

*   Android Emulator or Physical Device  workmanager: ^0.5.1

  

### Installation  # Native Features

  permission_handler: ^11.0.1

1.  **Clone the repository**  image_picker: ^1.0.4

    ```bash  url_launcher: ^6.2.1

    git clone https://github.com/yourusername/offs.git  

    cd offs  # Utilities

    ```  intl: ^0.18.1

  uuid: ^4.1.0

2.  **Install Dependencies**  logger: ^2.0.2

    ```bash  freezed_annotation: ^2.4.1

    flutter pub get  json_annotation: ^4.8.1

    ```  get_it: ^7.6.4

  injectable: ^2.3.2

3.  **Generate Code** (for Drift, Freezed, Injectable)

    ```bashDev Dependencies:

    dart run build_runner build --delete-conflicting-outputs  drift_dev: ^2.13.0

    ```  build_runner: ^2.4.6

  freezed: ^2.4.5

4.  **Run the App**  json_serializable: ^6.7.1

    ```bash  mockito: ^5.4.2

    flutter run  bloc_test: ^9.1.4

    ```  flutter_test:

    sdk: flutter

## 🧪 Testing```



The project includes unit and widget tests.### 2.2 Project Structure



```bash```

# Run all testslib/

flutter test├── main.dart

```├── app.dart

├── core/

## 🤝 Contributing│   ├── database/

│   │   ├── database.dart                  # Drift database configuration

Contributions are welcome! Please feel free to submit a Pull Request.│   │   ├── tables/

│   │   │   ├── tasks_table.dart

1.  Fork the project│   │   │   ├── inventory_table.dart

2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)│   │   │   ├── sync_queue_table.dart

3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)│   │   │   └── attachments_table.dart

4.  Push to the branch (`git push origin feature/AmazingFeature`)│   │   └── daos/

5.  Open a Pull Request│   │       ├── tasks_dao.dart

│   │       ├── inventory_dao.dart

## 📄 License│   │       └── sync_queue_dao.dart

│   ├── network/

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.│   │   ├── api_client.dart               # Dio configuration

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
