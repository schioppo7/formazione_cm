#!/bin/sh
set -eu

if [ -z "${DEPLOY_TARGET_PASSWORD:-}" ]; then
    echo "DEPLOY_TARGET_PASSWORD is required." >&2
    exit 1
fi

printf 'root:%s\n' "$DEPLOY_TARGET_PASSWORD" | chpasswd
unset DEPLOY_TARGET_PASSWORD

exec /usr/sbin/sshd -D -e
