# Pulsetrack — Developer README

This document contains the minimal steps to get the application running for local development.

## Prerequisites
- Ruby — see `.ruby-version` for the exact version to install (use rbenv or rvm).
- Node.js and a JS package manager (Yarn or npm).
- PostgreSQL (or the database specified in `config/database.yml`) running locally.
- Any other system dependencies referenced in `Gemfile` (run `bundle install`).
- Ensure you have the correct environment variables configured (see `.env` if present). Do not commit secrets.

## Setup (one-time)
1. Install Ruby and Node per your environment.
2. Install gems and JS packages:
   - bundle install
   - yarn install (or npm install)
3. Database setup:
   - If `bin/setup` exists: `bin/setup`
   - Otherwise:
     - bin/rails db:create
     - bin/rails db:migrate
     - bin/rails db:seed (if you need seed data)

## Starting the app (development)
Open separate terminals for these tasks:

1. Start the development server and asset watcher:
   - bin/dev
   This typically runs the Rails server and webpack/dev server (or equivalent) so the web UI is available.

2. Start the Rails job queue processor:
   - bin/jobs start
   This is required for background jobs to be processed (the app uses Rails queue for jobs). Keep this running in a separate terminal while developing.

Example (two terminal windows):
- Terminal A:
  - bin/dev
- Terminal B:
  - bin/jobs start

You can also run jobs in the foreground (if supported) for debugging:
- bin/jobs run

## Common commands
- Rails console: bin/rails console
- Run migrations: bin/rails db:migrate
- Run tests: bin/rails test
- Run a single job or run jobs interactively: bin/jobs run (if available)

## Environment and configuration
- Check `.ruby-version`, `config/database.yml`, and any initializers in `config/initializers` for required configuration.
- Environment variables: store local secrets in `.env` or your preferred mechanism. This repo typically ignores `.env` — do not commit it.

## Troubleshooting
- If background jobs are not processed, confirm `bin/jobs start` is running and check logs:
  - tail -f log/development.log
- If assets are not loading, ensure `bin/dev` is running and check the output for errors.
- If DB connection fails, verify PostgreSQL is running and credentials in `config/database.yml`/env are correct.

## Deployment notes
- Follow your platform's Rails deployment guide.
- Ensure background job process equivalent to `bin/jobs start` is configured in production (systemd, Heroku worker, cron, etc.).

## Further reading
- Inspect `config/application.rb`, `config/environments/development.rb`, and `config/initializers` for app-specific behavior and queue adapter configuration.
