# CustomFlix

CustomFlix is a self-hosted Flutter Web streaming-style app backed by Firebase.
It supports Google sign-in, an admin area, multilingual UI, and episode sync
from public Google Drive folders.

## Important legal notice

This project is meant for personal, lawful use only.

You must only use media that you:
- own
- created
- are licensed to access
- are otherwise legally allowed to stream or catalog

Do not use this project to distribute or facilitate access to pirated content.

Read the full notice in [LEGAL_USE.md](LEGAL_USE.md).

## What this project includes

- Flutter Web frontend
- Firebase Authentication with Google sign-in
- Firestore for catalog and access control
- Firebase Hosting
- Cloud Functions for Google Drive folder sync
- Admin-only catalog management
- Viewer allowlist support
- `pt-BR` and `en` UI support

## What this repository does not include

This repository does not ship with:
- a real Firebase project binding
- real Firebase web credentials
- a real admin email
- real user data
- real private Google Drive links

That is intentional so the project can remain safe to publish as source code.

## Prerequisites

Install these tools locally:
- Flutter
- Firebase CLI
- FlutterFire CLI
- Node.js and npm

You also need a Firebase project with:
- `Authentication > Google` enabled
- Firestore enabled
- Cloud Functions enabled
- Firebase Hosting enabled
- Google Drive API enabled in the linked Google Cloud project

## Project setup

### 1. Create your local env file

```bash
cp .env.example .env.local
```

Set your values in `.env.local`:

```bash
FIREBASE_PROJECT_ID=your-project-id
ADMIN_EMAIL=your-admin-email@example.com
```

### 2. Generate local Firebase files

Generate the local `.firebaserc`:

```bash
bash scripts/render_firebaserc.sh .env.local
```

Generate `firestore.rules` with your real admin email:

```bash
bash scripts/render_firestore_rules.sh .env.local
```

### 3. Generate the Firebase web configuration

```bash
flutterfire configure --project=your-project-id --platforms=web --yes
```

This regenerates `lib/firebase_options.dart` locally with your real Firebase
web app configuration.

### 4. Install dependencies

```bash
flutter pub get
cd functions && npm install && cd ..
```

## Running the app locally

Run Flutter Web and pass the admin email through `dart-define`:

```bash
flutter run -d chrome --dart-define=ADMIN_EMAIL=your-admin-email@example.com
```

## Deploy

### Automated deploy

Run the full deployment flow with:

```bash
bash scripts/deploy.sh .env.local all
```

Available targets:

```bash
bash scripts/deploy.sh .env.local setup
bash scripts/deploy.sh .env.local rules
bash scripts/deploy.sh .env.local functions
bash scripts/deploy.sh .env.local hosting
bash scripts/deploy.sh .env.local all
```

### Manual deploy

1. Render the local Firebase project file:

```bash
bash scripts/render_firebaserc.sh .env.local
```

2. Render Firestore rules:

```bash
bash scripts/render_firestore_rules.sh .env.local
```

3. Regenerate Firebase web config:

```bash
flutterfire configure --project="$FIREBASE_PROJECT_ID" --platforms=web --yes
```

4. Deploy Firestore rules:

```bash
firebase deploy --only firestore:rules --project "$FIREBASE_PROJECT_ID"
```

5. Deploy Functions:

```bash
firebase deploy --only functions --project "$FIREBASE_PROJECT_ID"
```

6. Build and deploy Hosting:

```bash
flutter build web --dart-define=ADMIN_EMAIL="$ADMIN_EMAIL"
firebase deploy --only hosting --project "$FIREBASE_PROJECT_ID"
```

## Open source and security notes

Do not commit:
- `.env.local`
- `.firebaserc`
- `.firebase/`
- secrets, service accounts, or access tokens
- a real `lib/firebase_options.dart`
- private Drive links
- real user emails or UIDs

Security must be enforced through:
- `firestore.rules`
- Firebase IAM
- Cloud Functions secrets or environment configuration
- your real Firebase project settings

## License

This repository is released under the [MIT License](LICENSE).

The code license does not grant permission to use copyrighted media unlawfully.
