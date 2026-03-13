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

if [ -z "${ADMIN_EMAIL:-}" ]; then
  echo "ADMIN_EMAIL is required in $ENV_FILE" >&2
  exit 1
fi

escaped_admin_email=$(printf '%s' "$ADMIN_EMAIL" | sed 's/[\/&]/\\&/g')
sed "s/__ADMIN_EMAIL__/$escaped_admin_email/g" firestore.rules.template > firestore.rules

echo "Generated firestore.rules for admin email: $ADMIN_EMAIL"
