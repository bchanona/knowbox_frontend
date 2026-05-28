# KnowBox

A cloud-based file management application built with Flutter. Users can upload, organize, and manage their files through a clean and intuitive interface.

## Architecture

The project follows **Clean Architecture** with a **feature-based** folder structure, separating concerns into three layers:

```
lib/
├── core/                          # Shared infrastructure
│   ├── di/                        # Dependency injection container
│   ├── errors/                    # Failure abstractions
│   ├── network/                   # HTTP client wrapper
│   └── storage/                   # Local token storage
├── features/                      # Feature modules
│   ├── auth/                      # Authentication module
│   │   ├── data/                  # Data layer
│   │   │   ├── datasource/remote/ # Remote data sources (API calls)
│   │   │   └── repositories_impl/ # Repository implementations
│   │   ├── domain/                # Domain layer (business logic)
│   │   │   ├── entities/          # Business models
│   │   │   ├── repositories/      # Abstract repository contracts
│   │   │   └── usecases/          # Application-specific business rules
│   │   ├── di/                    # Auth dependency injection
│   │   └── presentation/          # Presentation layer (UI)
│   │       ├── providers/         # State management (ChangeNotifier)
│   │       ├── screens/           # Full-page views
│   │       └── widgets/           # Reusable UI components
│   └── files/                     # File management module
│       ├── data/
│       ├── domain/
│       ├── di/
│       └── presentation/
└── shared/                        # Shared resources
    └── theme/                     # Material theming and typography
```

### Layer responsibilities

| Layer | Responsibility |
|-------|----------------|
| **Domain** | Entities, repository interfaces, use cases (pure Dart, no framework) |
| **Data** | DTOs, remote data sources, repository implementations |
| **Presentation** | Providers (ChangeNotifier), screens, widgets |
| **Core** | Shared infrastructure (HTTP client, DI container, storage, errors) |

## Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** (SDK ^3.11.5) | UI framework |
| **Provider** (^6.1.0) | State management |
| **http** (^1.2.0) | HTTP client for REST API |
| **shared_preferences** (^2.3.0) | Local token/user persistence |
| **google_fonts** (^8.1.0) | Lato + Playfair Display typography |
| **device_preview** (^1.3.1) | Device preview (enabled on web) |

## Routes

| Route | Page | Description |
|-------|------|-------------|
| `/` | `HomeViewPage` | Landing page with Sign In / Create Account buttons |
| `/login` | `LoginPage` | User login form |
| `/register` | `RegisterPage` | User registration form |
| `/dashboard` | `DashboardPage` | Main dashboard (post-login) |

## API Configuration

The app connects to a REST API at:

```
http://localhost:3001
```

Configure in `lib/core/di/app_container.dart:10`.

### Auth endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/auth/login` | User login |
| POST | `/auth/register` | User registration |

### Files endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/files/:userId` | List files for user |
| POST | `/files` | Create a file |
| PUT | `/files/:id` | Update a file |
| DELETE | `/files/:id` | Delete a file |

## State Management

The app uses `Provider` with `ChangeNotifier` pattern:

- **AuthProvider** — manages authentication state (login, register, session restore, logout)
- **FilesProvider** — manages file CRUD operations and state

Each provider exposes a state object (`AuthState` / `FilesState`) with a `status` enum (`initial`, `loading`, `success`, `error`) and an `errorMessage`.

## Dependencies

Auth module relies on:
- `core/network/http_client.dart` — centralized HTTP client with JWT token injection
- `core/storage/token_storage.dart` — persists JWT and user data via SharedPreferences
- `core/errors/failures.dart` — typed failure classes (ServerFailure, ConnectionFailure, UnexpectedFailure)

Files module relies on:
- Same `core/network/http_client.dart`
- `core/di/app_container.dart` — shared DI container

## Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

For web preview with DevicePreview enabled:
```bash
flutter run -d chrome
```
