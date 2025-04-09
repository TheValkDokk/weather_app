# Weather App

## Features

- Location-based weather updates

## Technical Architecture

### Architecture Pattern
The application follows the **Clean Architecture** pattern with **BLoC (Business Logic Component)** as the state management solution.

- Consistency with industry standards
- Easier onboarding
- Clear separation of concerns
- Testability
- Maintainability
- Scalability

The project structure is organized into three main layers:
- **Presentation Layer**: Contains UI components, BLoCs, and widgets
- **Domain Layer**: Contains business logic, entities, and use cases
- **Data Layer**: Handles data sources, repositories, and API calls

### Key Libraries and Frameworks

#### State Management
- **flutter_bloc**: For implementing the BLoC pattern
- **get_it**: For dependencies injections
- **injectable**: Code generation for get_it

#### Networking
- **dio**: For making HTTP requests
- **dio_intercept_to_curl**: For debugging network requests
- **connectivity_plus**: For checking network connectivity

#### Location Services
- **geolocator**: For getting device location
- **geocoding**: For reverse geocoding
- **permission_handler**: For handling location permissions

#### UI/UX
- **go_router**: For navigation
- **flutter_animate**: For animations
- **google_fonts**: For typography
- **intl**: For formatting

#### Code Generation
- **freezed**: For generating immutable classes
- **json_serializable**: For JSON serialization
- **build_runner**: For running code generators

#### Testing
- **mocktail**: For mocking dependencies
- **bloc_test**: For testing BLoCs
- **test**: For general testing utilities

## Project Structure

```
lib/
├── core/           # Core functionality and utilities
├── features/       # Feature modules
├── routes/         # Navigation routes
├── gen/            # Generated asset code
└── main.dart       # Application entry point
```

## Getting Started

1. Clone the repository
2. Install FVM (Flutter Version Manager):
   ```dart
   dart pub global activate fvm
   ```
3. Install the project's Flutter version:
   ```dart
   fvm install
   ```
4. Install dependencies:
   ```dart
   fvm flutter pub get
   ```
5. Generate necessary files:
   ```dart
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```
6. Run the application:
   ```dart
   fvm flutter run
   ```

## Testing

To run tests:
```dart
fvm flutter test
```