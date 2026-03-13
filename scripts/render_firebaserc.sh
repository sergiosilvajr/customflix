#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-.env.local}"

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

cat > .firebaserc <<EOF
{
  "projects": {
    "default": "$FIREBASE_PROJECT_ID"
  }
}
EOF

echo "Generated .firebaserc for project: $FIREBASE_PROJECT_ID"
