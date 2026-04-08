# Daily Gym API

A Rails API-only application for managing workouts, exercises, and training plans.

## Stack

- Ruby 3.4.4 / Rails 8.1 (API-only)
- PostgreSQL 17
- Devise + devise-jwt (JWT authentication)
- RSpec + FactoryBot + FFaker (testing)
- RuboCop Rails Omakase + Brakeman (code quality & security)

## Domain

- **User** → has many `WorkoutSession` and `WorkoutPlan`
- **Exercise** → global exercises (unique name)
- **WorkoutSession** → user's training session; contains exercises via `WorkoutSessionExercise` (sets, reps, weight, technique)
- **WorkoutPlan** → groups multiple `WorkoutSession` via `WorkoutPlanSession`
- **JwtBlacklist** → JWT token revocation on logout

## Authentication

JWT via `devise-jwt`. Token expires in 24h.

- Login: `POST /users/sign_in` → returns token in response body
- Logout: `DELETE /users/sign_out` → revokes token (blacklist)
- Header: `Authorization: <token>`

## API Endpoints

```
POST   /users/sign_in
POST   /users
DELETE /users/sign_out

GET    /api/v1/exercises
POST   /api/v1/exercises
GET    /api/v1/exercises/:id
PUT    /api/v1/exercises/:id
DELETE /api/v1/exercises/:id

GET    /api/v1/workout_sessions
POST   /api/v1/workout_sessions
GET    /api/v1/workout_sessions/:id
PUT    /api/v1/workout_sessions/:id
DELETE /api/v1/workout_sessions/:id

GET    /health_check
```

## Getting Started

### Requirements

- Docker
- Docker Compose

### Setup

```bash
# 1. Clone the repository
git clone <repo-url>
cd daily_gym_api

# 2. Copy the environment file
cp .env.example .env  # fill in SECRET_KEY_BASE

# 3. Build the Docker image
make build

# 4. Start the app and database
make start
```

### Database

```bash
# Open a bash session inside the container
make bash

# Then run:
bin/rails db:create db:migrate
bin/rails db:seed   # loads 63+ exercises and a demo user
```

Demo user after seed: `jorgedjr21@gmail.com` / `123456789` (role: admin)

## Environment Variables

| Variable            | Description                  | Default    |
|---------------------|------------------------------|------------|
| `SECRET_KEY_BASE`   | Rails secret key             | required in production |
| `DATABASE_USER`     | PostgreSQL user              | postgres   |
| `DATABASE_PASSWORD` | PostgreSQL password          | password   |
| `DATABASE_HOST`     | Database host                | localhost  |
| `RAILS_MAX_THREADS` | DB connection pool size      | 5          |

When running with Docker, these variables are set in `docker-compose.yml`. For local development outside Docker, use the `.env` file (loaded automatically by `dotenv-rails`).

Generate a secret key with:

```bash
bin/rails secret
```

## Running Tests

```bash
make specs
# or inside the container:
bundle exec rspec
```

- Request specs (integration): `spec/requests/`
- Model specs (unit): `spec/models/`
- Factories: `spec/factories/`

## CI/CD

GitHub Actions pipeline at `.github/workflows/ci.yml`, runs on PRs and pushes to `main`:

1. Brakeman (security scan)
2. RuboCop (code style)
3. RSpec (full test suite with PostgreSQL)

Requires `SECRET_KEY_BASE` secret configured in the repository.

## Internationalization

Supports `en` and `pt`. Locale selected via `Accept-Language` header.
