#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-.env.local}"
TARGET="${2:-all}"

if [ ! -f "$ENV_FILE" ]; then
  echo "Missing env file: $ENV_FILE" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

if [ -z "${FIREBASE_PROJECT_ID:-}" ]; then
  echo "FIREBASE_PROJECT_ID is required in $ENV_FILE" >&2
  exit 1
fi

if [ -z "${ADMIN_EMAIL:-}" ]; then
  echo "ADMIN_EMAIL is required in $ENV_FILE" >&2
  exit 1
fi

run_setup() {
  bash scripts/render_firebaserc.sh "$ENV_FILE"
  bash scripts/render_firestore_rules.sh "$ENV_FILE"
  flutterfire configure --project="$FIREBASE_PROJECT_ID" --platforms=web --yes
}

run_rules() {
  firebase deploy --only firestore:rules --project "$FIREBASE_PROJECT_ID"
}

run_functions() {
  (
    cd functions
    npm install
  )
  firebase deploy --only functions --project "$FIREBASE_PROJECT_ID"
}

run_hosting() {
  flutter build web --dart-define=ADMIN_EMAIL="$ADMIN_EMAIL"
  firebase deploy --only hosting --project "$FIREBASE_PROJECT_ID"
}

case "$TARGET" in
  setup)
    run_setup
    ;;
  rules)
    bash scripts/render_firestore_rules.sh "$ENV_FILE"
    run_rules
    ;;
  functions)
    run_functions
    ;;
  hosting)
    run_hosting
    ;;
  all)
    run_setup
    run_rules
    run_functions
    run_hosting
    ;;
  *)
    echo "Unknown target: $TARGET" >&2
    echo "Usage: bash scripts/deploy.sh [env-file] [setup|rules|functions|hosting|all]" >&2
    exit 1
    ;;
esac
