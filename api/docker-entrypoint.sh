#!/usr/bin/env sh

# Exit on error.
set -e
rails db:create
rails db:migrate
rails db:seed
rm -f tmp/pids/server.pid
exec "$@"
