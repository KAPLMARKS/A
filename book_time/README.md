# Book Time

A Flutter productivity app implementing the Pomodoro Technique with task management and comprehensive statistics tracking.

## 🎮 Main Functionality

**Book Time** is a productivity application that helps users maintain focus and manage their work sessions using the Pomodoro Technique. The app includes:

- **Home Screen**: Main timer interface with three modes:
  - **Focus Mode**: 25-minute work sessions
  - **Short Break**: 5-minute rest periods
  - **Long Break**: 15-minute extended breaks
  - Features include:
    - Animated circular timer with progress visualization
    - Play, pause, and skip controls
    - Active task display
    - Motivational quotes
    - Automatic mode switching
    - Session completion tracking
- **Tasks Screen**: Task management system where users can:
  - Create, edit, and delete tasks
  - Organize tasks by categories
  - Set active tasks for timer sessions
  - View task completion statistics
- **Profile Screen**: Comprehensive statistics and achievements dashboard showing:
  - User summary with total focus time
  - Focus level indicators
  - Weekly activity charts
  - Task completion statistics
  - Achievement badges and progress
  - Performance metrics and insights

## 🏗️ Architecture

The project follows **Clean Architecture** principles with clear separation of concerns:

- **Presentation Layer**: UI components, screens, widgets, and state management using BLoC pattern
- **Domain Layer**: Business logic, entities (e.g., `Task`, `TimerMode`, `Statistics`, `Achievement`), repository interfaces, and use cases
- **Data Layer**: Local data sources, repository implementations, and models (e.g., `TaskModel`)

### Key Architectural Features

- **State Management**: BLoC pattern with Events and States for timer, tasks, and profile management
- **Dependency Injection**: GetIt service locator for managing dependencies
- **Navigation**: GoRouter with bottom navigation for seamless screen transitions
- **Reusable Components**: Shared widgets library including custom dialogs and stat cards
- **Service Layer**: Modular services for storage management and logging
- **Theme System**: Centralized theming with custom colors, fonts, spacing, and glass morphism effects
- **Data Persistence**: Local storage using SharedPreferences for tasks, statistics, and timer state

## 🛠️ Tech Stack

- **Flutter** with Dart
- **flutter_bloc** for state management
- **go_router** for navigation
- **get_it** for dependency injection
- **shared_preferences** for local data storage
- **equatable** for value equality
- **liquid_glass_renderer** for glass morphism UI effects
- **talker_flutter** & **talker_bloc_logger** for logging and debugging

## 📱 Features

- Pomodoro timer with three modes (Focus, Short Break, Long Break)
- Task management with categories
- Active task integration with timer
- Comprehensive statistics tracking
- Achievement system
- Weekly activity visualization
- Motivational quotes
- Local data persistence
- Smooth animations and transitions

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: 3.24.x or higher
- **Dart SDK**: 3.10.4 or higher (as specified in `pubspec.yaml`)

### Installation

1. Extract the project archive to your desired location

2. Navigate to the project directory:
   ```bash
   cd focus_time
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 📝 Notes

- The app uses local storage (SharedPreferences) for tasks, statistics, and timer state
- Timer state persists across app restarts
- All statistics are calculated and stored locally
- The app implements the standard Pomodoro Technique timing (25/5/15 minutes)
- Glass morphism UI design provides a modern, professional appearance
