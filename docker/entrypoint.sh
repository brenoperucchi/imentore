#!/usr/bin/env bash
set -e

rm -f /app/imentore-base/tmp/pids/server.pid

if [ -n "${DATABASE_HOST:-}" ]; then
  until ruby -rsocket -e "TCPSocket.new(ENV.fetch('DATABASE_HOST'), ENV.fetch('DATABASE_PORT', '3306')).close" >/dev/null 2>&1; do
    sleep 1
  done
fi

exec "$@"
