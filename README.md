# Punch In/Out System for Superstores

A modern time tracking system built with Flutter and Spring Boot, designed for superstore employees to track their work hours efficiently.

## Features

- **User Authentication**
  - Secure account creation
  - PIN-based authentication
  - Session management

- **Time Tracking**
  - Real-time punch in/out functionality
  - Live timer display
  - Detailed punch-in history
  - Duration tracking

- **Modern UI/UX**
  - Clean and intuitive interface
  - Real-time status updates
  - Responsive design
  - Visual feedback for actions

## Tech Stack

### Frontend (Flutter)
- **State Management**: Flutter BLoC
- **Dependency Injection**: GetIt
- **Network**: Dio
- **Local Storage**: SharedPreferences
- **UI Components**: Material Design

### Backend (Spring Boot)
- **Framework**: Spring Boot
- **Database**: PostgreSQL
- **ORM**: Spring Data JPA
- **API**: RESTful

## Project Structure

```
punchin_punchout_system/
├── lib/
│   ├── blocs/          # State management
│   ├── models/         # Data models
│   ├── services/       # API and storage services
│   ├── views/          # UI screens
│   └── di/             # Dependency injection
└── server/
    ├── controllers/    # REST endpoints
    ├── services/       # Business logic
    ├── repositories/   # Data access
    └── entities/       # Database models
```

## Getting Started

### Prerequisites
- Flutter SDK
- Java JDK 17+
- PostgreSQL
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/abdulsalamdeveloper1999/abdulsalamdeveloper1999-punchin-punchout-flutter-bloc-springboot-postgres/tree/main
   ```

2. **Backend Setup**
   ```bash
   cd server
   ./mvnw spring-boot:run
   ```

3. **Frontend Setup**
   ```bash
   cd punchin_punchout_system
   flutter pub get
   flutter run
   ```

### Configuration

1. **Database Configuration**
   - Update `application.properties` with your PostgreSQL credentials
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/punchin_punchout_db
   spring.datasource.username=your_username
   spring.datasource.password=your_password
   ```

2. **API Configuration**
   - Update `baseUrl` in `api_service.dart` if needed
   ```dart
   final String baseUrl = 'http://localhost:8080/api';
   ```

## Usage

1. **Create Account**
   - Launch the app
   - Enter username and password
   - Get your unique PIN

2. **Punch In/Out**
   - Enter your PIN
   - Use "Punch In" to start tracking time
   - Use "Punch Out" to end your session

3. **View Time**
   - Real-time duration display
   - Punch-in history
   - Total work duration

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter Team for the amazing framework
- Spring Boot Team for the robust backend framework
- All contributors who have helped shape this project 
