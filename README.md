# SAMPNET

A fullstack workspace and HR management platform. Teams can manage employees, tasks, projects, attendance, leave, internal chat, and notifications from a single application.

## Tech Stack

**Frontend**
- Flutter (web and mobile)
- BLoC for state management
- Clean architecture: domain, data, presentation layers per feature
- GoRouter for navigation
- GetIt for dependency injection
- fpdart for functional error handling (Either/Left/Right)

**Backend**
- Go with Gin
- GORM with PostgreSQL
- JWT-based authentication
- WebSocket support for real-time notifications, chat, and presence

## Features

| Feature | Status | Description |
|---|---|---|
| Auth | Complete | Sign in, sign up, forgot password, email verification |
| Tasks | Complete | CRUD, comments, attachments, activity log, multiple views |
| Projects | Complete | Milestones, Gantt timeline, project detail |
| Teams | Complete | Create, edit, member management |
| Employees | Complete | Directory, profiles, invites, promote to manager |
| Attendance | Complete | Check-in and check-out with camera, admin view, history |
| Leave | Complete | Request, approve/reject, cancel, manager view, balance tracking |
| Chats | Complete | Real-time messaging, group chats, calls |
| Notifications | Complete | WebSocket-driven, paginated, mark read/unread |
| Onboarding | Complete | First-login wizard for new employees |
| Audit log | Frontend done, backend in progress | Activity log viewing and export |
| Global search | Complete | Cross-entity search across tasks, projects, teams, employees, chats |
| Settings | In progress | Profile, organisation, role permissions, policy configuration |
| Analytics | In progress | Org and team-level dashboards |
| Calendar | In progress | Personal and team calendar views |
| People directory | In progress | Org-wide people search and browsing |
| Resources | In progress | File upload, storage, and browsing |
| Research | In progress | Research entry tracking |
| Database | Planned | Custom user-defined tables for product and inventory data |

## Project Structure

### Frontend (Flutter)

```
lib/
  features/
    auth/
    attendence/
    audit/
    calendar/
    chats/
    company/
    dashboards/
    database/
    employees/
    landing/
    leave/
    notifications/
    onboarding/
    people/
    projects/
    research/
    resources/
    search/
    settings/
    tasks/
    team/
    upload_files/
  globals/
    constants/
    models/
    error_handling/
  services/
    routes.dart
    api_client.dart
    websocket_service.dart
  dependency_injection.g.dart
  main.dart
```

Each feature follows the same internal layout:

```
feature_name/
  domain/
    entities/
    repositories/
    use_cases/
  data/
    data_sources/
    models/
    repositories_impl/
  presentation/
    blocs/
    pages/
    widgets/
```

### Backend (Go)

```
internal/
  domain/        # entities and repository/usecase interfaces per feature
  usecase/        # business logic implementations
  adapters/
    http/        # Gin handlers and route registration per feature
    repository/  # GORM repository implementations per feature
  platform/
    database/    # connection, migrations, models
    middlewares/ # auth validation, etc.
    websocket/   # hub, client, broadcaster, presence tracker
  app/
    routes/      # central route wiring
```

## Architecture Notes

- The Go backend follows a consistent layer order for every feature: domain entity, repository interface, usecase interface, usecase implementation, GORM repository implementation, HTTP handler, then route registration in `internal/app/routes/routes.go`.
- The Flutter frontend follows clean architecture per feature: domain entities and use cases, data sources and repository implementations, then BLoC-driven presentation.
- Every protected API route is guarded by JWT middleware that resolves `userID`, `organisationID`, and `role` from the token and attaches them to the request context.
- All queries that touch organisation-scoped data must filter by `organisation_id` to prevent cross-tenant data leaks.

## Getting Started

### Backend

```bash
cd backend
go mod download
go run ./src/main.go
```

Set up a `.env` file with your PostgreSQL connection string and JWT secret before running. The server runs migrations on startup against the models registered in `internal/platform/database/init.go`.

### Frontend

```bash
cd frontend
flutter pub get
flutter run
```

Update `globals/constants/api_end_points.dart` if your backend is not running on the default local address.

## Contributing

When adding a new feature, follow the existing layer structure on both sides rather than introducing a new pattern. Register new backend routes in `internal/app/routes/routes.go` and new frontend routes in `services/routes.dart`. Add new dependencies to `dependency_injection.g.dart` following the existing registration style for that layer (data source as singleton, repository as singleton, usecase as singleton, bloc as factory).

## License

Internal project. License terms to be determined.
