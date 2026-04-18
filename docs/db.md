# Database Documentation (Drift)

This project uses **Drift** (formerly Moor) as a persistent reactive database for Flutter.

## Database File
- **Location**: `lib/database/db.dart`
- **Native Path**: `getApplicationSupportDirectory` / `easy_tasweeh_db`

## Tables

### 1. `CurrentCountTable`
Tracks the active counter session.
- `id`: `Int` (Auto-increment, Primary Key)
- `targetCount`: `Int` (Goal for the session, default: 0)
- `currentCount`: `Int` (Accumulated count, default: 0)
- `createdAt`: `DateTime` (Timestamp when session started)
- `updatedAt`: `DateTime` (Timestamp of last count update)

### 2. `CountHistoryTable`
Stores completed or past counter sessions.
- `id`: `Int` (Auto-increment, Primary Key)
- `targetCount`: `Int` (Goal for the session)
- `currentCount`: `Int` (Final count reached)
- `createdAt`: `DateTime` (Timestamp of completion)
- `updatedAt`: `DateTime` (Last update timestamp)

## DAOs (Data Access Objects)
- **`CurrentCountDao`**: `lib/database/dao/current_count_dao.dart` - Handles operations for the active session.
- **`CountHistoryDao`**: `lib/database/dao/count_history_dao.dart` - Handles historical records and statistics.

## Status & Requirements

### What we have:
- [x] Basic schema for current session and history.
- [x] Drift generation setup (`db.g.dart`).
- [x] Riverpod integration (`appDatabaseProvider`).

### What we need:
- [ ] Migration strategies for future schema changes.
- [ ] Export/Import database functionality (for backups).
- [ ] More granular statistics (daily, weekly, monthly views).
- [ ] Tags/Categories for different types of Dhikr.
