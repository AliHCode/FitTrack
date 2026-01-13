# FitTrack Mobile App

A comprehensive fitness tracking application built with Flutter and Supabase.

## Project Overview

FitTrack helps users track their daily nutrition, exercise, and health goals.
**Key Features:**
- **User Authentication:** Sign up, Login, Forgot Password (via Supabase Auth).
- **Profile Management:** Set fitness details (height, weight, age) and upload a profile picture.
- **Calorie & Macro Tracking:** Log meals using the USDA food database.
- **Activity Logging:** Track exercises and calories burned.
- **Dashboard:** Visual summary of daily progress.
- **Settings:** Manage account preferences and send feedback.

## Prerequisites

To run this project, you need:
1.  **Flutter SDK** (Channel stable, recommended version 3.x).
2.  **Dart SDK** (included with Flutter).
3.  **Android Studio** or **VS Code** with Flutter extensions.
4.  **Internet Connection** (Required for Supabase backend and food search API).

## Installation & Setup

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd FitTrack
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the App:**
    Connect an Android/iOS device or start an emulator, then run:
    ```bash
    flutter run
    ```
    *Note: The app is configured with Supabase credentials out-of-the-box, so it should connect to the live backend immediately.*

## Database Setup (Optional)

The project connects to a hosted Supabase instance by default. If you wish to set up your own backend:

1.  Create a new project on [Supabase.com](https://supabase.com).
2.  Run the contents of `schema.sql` (found in the root directory) in your Supabase **SQL Editor**.
3.  Update `lib/services/api_service.dart` with your new `projectId` and `publicAnonKey` (found in API Settings).

## Project Structure

- `lib/pages/`: Application screens (Login, Home, Profile, Food Log, etc.).
- `lib/services/`: API handling for Supabase and USDA food search.
- `lib/models/`: Data models (FoodItem, UserProfile, etc.).
- `lib/providers/`: State management (AppState).
- `schema.sql`: Database creation script.
