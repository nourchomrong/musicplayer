# MusicPlayer

A full-stack music player project with a Laravel backend and a Flutter frontend.

## Overview

- `backend/` - Laravel API server, authentication, OTP-based password reset, mail delivery, and database storage.
- `frontend/` - Flutter application for user sign-in, registration, password recovery, and music player UI.

## Tech Stack

- Backend:
  - Laravel 12
  - PHP 8.2
  - Laravel Sanctum for API token authentication
  - Laravel Livewire for server-driven UI components
  - MySQL / SQLite / database drivers via Laravel configuration
  - Email/OTP support via `Illuminate\Mail` and custom `OtpMail`
  - Frontend assets built with Vite

- Frontend:
  - Flutter
  - Dart SDK ^3.11.5
  - `http` for REST API calls
  - `provider` for state management
  - `shared_preferences` for local auth token persistence
  - `flutter_svg` for rendering vector assets
  - `flutter_launcher_icons` for app icon generation

## Key Features

- User registration and login
- Email and username availability checks
- Password reset flow using email OTP codes
- API token-based auth storage in Flutter
- Backend mail delivery using SMTP or log driver
- SQLite default setup with support for other Laravel-supported databases

## Backend Details

### Primary backend components

- `backend/app/Http/Controllers/AuthController.php`
  - `register`
  - `login`
  - `logout`
  - `checkEmail`
  - `checkUsername`
  - `forgotPassword`
  - `verifyCode`
  - `resetPassword`

- `backend/app/Mail/OtpMail.php`
  - sends password reset codes to users

- `backend/app/Models/Otp.php`
  - stores OTP codes and expiration timestamps

- `backend/database/migrations/` contains tables for users and OTP storage.

### Mail and OTP setup

- Default mail configuration is defined in `backend/.env.example`.
- For local testing, set `MAIL_MAILER=log` to write outgoing mail to logs.
- For real email delivery, configure SMTP values in `backend/.env`:

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=465
MAIL_ENCRYPTION=ssl
MAIL_USERNAME=your-smtp-user
MAIL_PASSWORD=your-smtp-password
MAIL_FROM_ADDRESS=your-from-address@example.com
MAIL_FROM_NAME="Music Player"
```

- If using Gmail SMTP, enable app passwords or configure OAuth credentials as required.
- The OTP system generates a 6-digit code, stores it in `otps`, and expires codes after 15 minutes.

### Backend API notes

- API URL base is typically `http://<host>:8000/api`
- Run the server with `php artisan serve --host 0.0.0.0` when testing from a device or emulator.
- Ensure `frontend/lib/config/api_config.dart` matches the backend host.

## Frontend Details

### Important frontend files

- `frontend/lib/config/api_config.dart`
  - defines `ApiConfig.baseUrl`
- `frontend/lib/controller/auth_controller.dart`
  - handles login, registration, token storage, forgot password, verify code, and reset password flows
- `frontend/lib/screens/auth/`
  - login, register, forget password, verify code, reset password screens
- `frontend/lib/screens/home/home_screen.dart`
  - protected home screen after authentication

### API configuration

- `frontend/lib/config/api_config.dart` currently uses:

```dart
static const String baseUrl = "http://192.168.1.3:8000/api";
```

- Update this value for your machine or emulator:
  - Physical Android device: use your computer's LAN IP (e.g. `http://192.168.1.10:8000/api`)
  - Android emulator: use `http://10.0.2.2:8000/api`
  - iOS simulator: use `http://127.0.0.1:8000/api` if the host is reachable

## Getting Started

### Backend Setup

1. Navigate to the backend folder:

```bash
cd backend
```

2. Install PHP dependencies:

```bash
composer install
```

3. Copy the environment file and generate an app key:

```bash
copy .env.example .env
php artisan key:generate
```

4. Configure `backend/.env`:
  - database connection settings
  - mail settings for SMTP or `log`
  - `APP_URL` if needed

5. Run database migrations:

```bash
php artisan migrate
```

6. Install frontend asset dependencies and build assets:

```bash
npm install
npm run build
```

7. Start the backend server for device access:

```bash
php artisan serve --host 0.0.0.0
```

### Frontend Setup

1. Navigate to the frontend folder:

```bash
cd frontend
```

2. Install Flutter dependencies:

```bash
flutter pub get
```

3. Generate launcher icons if needed:

```bash
flutter pub run flutter_launcher_icons:main
```

4. Update `frontend/lib/config/api_config.dart` to point at your backend API.

5. Run the app:

```bash
flutter run
```

> Add `-d <device-id>` to target a specific device.

## Running the Full Stack

1. Start the backend server.
2. Confirm the backend is reachable from the device or emulator.
3. Run the Flutter app.
4. Use the app's auth screens to register, log in, recover password, and verify OTP.

## Testing

### Backend

```bash
cd backend
php artisan test
```

### Frontend

```bash
cd frontend
flutter test
```

## Useful Commands

### Backend

- `composer install`
- `php artisan migrate`
- `php artisan serve --host 0.0.0.0`
- `npm install`
- `npm run build`

### Frontend

- `flutter pub get`
- `flutter pub run flutter_launcher_icons:main`
- `flutter run`
- `flutter test`

## Notes

- The backend includes a Laravel boilerplate README at `backend/README.md`.
- The frontend includes a Flutter starter README at `frontend/README.md`.
- Keep `.env` files private and do not commit secrets.
- Configure mail settings for OTP delivery before using password reset flows.

## License

This project inherits licenses from Laravel and Flutter dependencies. Add a project-specific license if desired.
