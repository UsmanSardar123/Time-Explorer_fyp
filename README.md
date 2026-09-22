# timeexplorer

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

API keys are stored in environment variables.

## Running With Pixabay

Flutter does not load `backend/.env` into the mobile app. Pass the Pixabay key
at build/run time instead:

```powershell
flutter run --dart-define=PIXABAY_API_KEY=$env:PIXABAY_API_KEY
```

The app logs only whether the key is present. If Pixabay is unavailable or the
key is missing, the gallery continues with Wikimedia/Wikipedia images.
