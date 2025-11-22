# OFFS (Offline-First Flutter Sync)# offs



OFFS is a robust, production-ready mobile application built with Flutter that demonstrates a complete **Offline-First** architecture. It allows users to manage tasks and inventory seamlessly without an internet connection, intelligently syncing data with a backend server when connectivity is restored.# Offline-First Field Service App - Complete Technical Specification



# Key Features Executive Summary



*   **Offline-First Design**: All data is stored locally first using SQLite (Drift), ensuring the app is always fast and responsive regardless of network status.Build a production-ready mobile application for field service workers (delivery drivers, warehouse staff, technicians) who operate in areas with unreliable internet connectivity. The app must function completely offline, with intelligent background synchronization when connectivity is restored.

*   **Background Synchronization**: Uses `WorkManager` to reliably sync data in the background, even when the app is closed.

*   **Conflict Resolution**: Implements a robust strategy to handle data conflicts between local changes and server updates, with a UI for manual resolution when necessary.---

*   **Task Management**: Create, read, update, and delete tasks with due dates and status tracking.

*   **Inventory Management**: Track inventory items, update quantities, and search through the catalog with optimistic UI updates.

*   **Sync Status Visibility**: Real-time UI indicators showing sync status (Syncing, Synced, Error, Offline) and a dedicated queue page to view pending operations.

*   **Modern UI/UX**: Clean, responsive interface built with Material 3, supporting both Light and Dark modes.

### 1.1 Problem Statement

Field workers need to:

## 🛠 Tech Stack- Access task lists and inventory data without internet

- Update inventory quantities and task statuses in real-time

*   **Framework**: [Flutter](https://flutter.dev/)- Capture photos and scan barcodes without connectivity

*   **Language**: [Dart](https://dart.dev/)- Never lose data due to connection issues

*   **State Management**: [Flutter Bloc](https://pub.dev/packages/flutter_bloc)- Automatically sync all changes when back online

*   **Local Database**: [Drift](https://pub.dev/packages/drift) (SQLite abstraction)

*   **Networking**: [Dio](https://pub.dev/packages/dio)

*   **Dependency Injection**: [GetIt](https://pub.dev/packages/get_it) & [Injectable](https://pub.dev/packages/injectable)A Flutter mobile application with:

*   **Background Tasks**: [WorkManager](https://pub.dev/packages/workmanager)- **Local-First Architecture**: SQLite (Drift) as the single source of truth

*   **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart)- **Offline-First Design**: All features work without internet

*   **Code Generation**: [Freezed](https://pub.dev/packages/freezed), [JsonSerializable](https://pub.dev/packages/json_serializable)- **Background Sync**: WorkManager handles automatic synchronization

- **Conflict Resolution**: Intelligent handling of data conflicts

## 🏗 Architecture- **Native Integration**: Android platform channels for performance-critical features



The project follows a **Clean Architecture** approach, separated by features:
### 1.3 Success Criteria

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

  
### Data Flow Architecture

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
