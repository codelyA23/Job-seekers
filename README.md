# Remote Jobs App

A Flutter application for browsing and saving remote job listings. The app provides a clean, user-friendly interface to explore various remote job opportunities across different industries and locations.

## Features

- Browse remote job listings from various sources
- Search and filter jobs by type, location, and company
- View detailed job descriptions
- Save favorite jobs for later
- Responsive design that works on both mobile and tablet
- Offline support for saved jobs

## Screenshots
*(Screenshots will be added here after the first release)*

## Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Networking**: http
- **Local Storage**: Shared Preferences
- **UI**: Material Design 3
- **Dependency Injection**: Provider

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions
- An emulator or physical device for testing

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/remote-jobs-app.git
   cd remote-jobs-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart          # Application entry point
├── models/           # Data models
├── providers/        # State management
├── screens/          # App screens
├── services/         # API and business logic
├── utils/            # Helper functions and constants
└── widgets/          # Reusable UI components
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Flutter](https://flutter.dev/) for the amazing cross-platform framework
- [RemoteOK API](https://remoteok.io/) for the job listings
- All the open-source packages that made this project possible
