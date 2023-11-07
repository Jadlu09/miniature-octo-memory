# Flutter Firebase Authentication Scaffold

This project provides a scaffold for implementing Firebase authentication in a Flutter application, runnable in GitHub Codespaces.

## Getting Started with Codespaces

To prepare your GitHub Codespace for Flutter development:

1. Navigate to your GitHub repository.
2. Click on the `Code` button.
3. Select `Codespaces`.
4. Click `Create new Codespace`.

**Note:** Stop your Codespace when done to prevent unnecessary credit usage.

## Firebase Setup

Before installation:

1. Go to the [Firebase Console](https://console.firebase.google.com/).
2. Click on `Add project` and follow the instructions to create a new Firebase project.
3. Once the project is created, navigate to the `Authentication` section.
4. In the `Sign-in method` tab, enable `Email/Password` authentication.

## Installation

Once your Codespace is ready:

1. Open the terminal.
2. Run `flutter pub get` to install dependencies.
3. Authenticate with Firebase using `firebase login`.
4. Run `flutterfire configure` to connect your app with the Firebase project.
5. Move `firebase_options.dart` from `lib` to `lib/config` with `mv lib/firebase_options.dart lib/config/firebase_options.dart`.

## Security Note

**Important:** Never publish API keys or other sensitive credentials in public repositories. The files that contain these credentials include:

- `lib/config/firebase_options.dart`
- `android/app/google-services.json`
- `ios/firebase_app_id_file.json`
- `macos/firebase_app_id_file.json`

These files should be kept out of version control to protect your Firebase account and services. For an example of how to set up your `.gitignore` to exclude these files, refer to the `.gitignore` file in this repository.

## Running the Application

Before running the app:

1. Open port 3000:
   - In the `Ports` tab, right-click on `3000`.
   - Select `Port Visibility`.
   - Choose `Public`.

To start the app:

- Execute `./run.sh` in the terminal.
- After the build, in `Ports`, right-click on `3000` and select `Open in Browser`.
