#!/bin/bash
set -euxo pipefail

# Remove a potentially pre-existing server.pid for Rails.
if [ -f $APP/tmp/pids/server.pid ]; then
    rm $APP/tmp/pids/server.pid
fi

PGHOST=${PGHOST:-postgres}
PGUSER=${PGUSER:-postgres}

RETRIES=0
MAX_RETRIES=${MAX_RETRIES:-10}
until psql --host="$PGHOST" --user="$PGUSER" --command "\q" >/dev/null 2>&1 || [ "$RETRIES" -eq "$MAX_RETRIES" ]; do
  echo >&2 "Waiting $((RETRIES += 1))s for the \"$PGHOST\" PostgreSQL server to start. $((MAX_RETRIES - RETRIES)) remaining attempts..."
  sleep "$RETRIES"
  false
done || exit 1

# Run migrations if necessary.
echo "Running migrations if necessary..."
#bundle exec rake db:migrate 2>/dev/null || ./bin/setup
bundle exec rake db:drop
bundle exec rake db:create
bundle exec rake db:migrate

# Start the rails server.
bundle exec rails s -b 0.0.0.0 -p ${EXPOSE_PORT:-3000}
