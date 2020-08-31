#!/bin/bash
set -euxo pipefail

# Remove a potentially pre-existing server.pid for Rails.
if [ -f $APP/tmp/pids/server.pid ]; then
    rm $APP/tmp/pids/server.pid
fi

# Exec sidekiq
bundle exec sidekiq -C ./config/sidekiq.yml
