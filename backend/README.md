# Time Explorer — Node Backend

> Admin/API server only. The Flutter app runs independently without this.

## Run Flutter app

```bash
flutter pub get
flutter run
```

No `.env` needed. Firebase is configured via `lib/firebase_options.dart`.

## Run Node backend (optional, admin APIs only)

```bash
cd backend
cp .env.example .env
# Edit .env — paste your Firebase service account JSON into FIREBASE_SERVICE_ACCOUNT_KEY
npm run dev
```

Server starts on `http://localhost:5000`.  
Routes: `GET /api/health`, `/api/users`, `/api/places`, `/api/personalities`.
