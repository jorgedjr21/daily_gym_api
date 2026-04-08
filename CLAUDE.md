# Daily Gym API

Rails API-only para gerenciamento de treinos, exercícios e planos de treinamento.

## Stack

- Ruby 3.4.4 / Rails 8.1 (API-only)
- PostgreSQL 17
- Devise + devise-jwt (autenticação via JWT)
- RSpec + FactoryBot + FFaker (testes)
- RuboCop Rails Omakase + Brakeman (qualidade e segurança)

## Estrutura de domínio

- **User** → tem muitos `WorkoutSession` e `WorkoutPlan`
- **Exercise** → exercícios globais (nome único)
- **WorkoutSession** → sessão de treino do usuário; contém exercícios via `WorkoutSessionExercise` (join com sets, reps, peso, técnica)
- **WorkoutPlan** → plano que agrupa `WorkoutSession` via `WorkoutPlanSession`
- **JwtBlacklist** → revogação de tokens JWT no logout

## Autenticação

JWT via `devise-jwt`. Token expira em 24h.

- Login: `POST /users/sign_in` → retorna token no body
- Logout: `DELETE /users/sign_out` → revoga token (blacklist)
- Header: `Authorization: <token>`
- Controllers protegidos com `authenticate_user!`

## Rotas principais

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

## Comandos Docker (desenvolvimento)

```bash
make build    # Build da imagem
make start    # Sobe app + banco (docker compose up)
make bash     # Abre bash no container
make specs    # Roda toda a suite de testes
```

## Banco de dados

```bash
# Dentro do container (make bash)
bin/rails db:create db:migrate
bin/rails db:seed   # Carrega 63+ exercícios e usuário demo
```

Usuário demo após seed: `jorgedjr21@gmail.com` / `123456789` (role: admin)

## Testes

```bash
make specs
# ou dentro do container:
bundle exec rspec
```

- Request specs (integração): `spec/requests/`
- Model specs (unitários): `spec/models/`
- Factories: `spec/factories/`

## CI/CD (GitHub Actions)

Pipeline em `.github/workflows/ci.yml`, roda em PRs e pushes para `main`:

1. Brakeman (segurança)
2. RuboCop (estilo)
3. RSpec (testes com PostgreSQL em container)

Requer secret `SECRET_KEY_BASE` no repositório.

## Variáveis de ambiente

| Variável            | Descrição                        | Padrão     |
|---------------------|----------------------------------|------------|
| `SECRET_KEY_BASE`   | Chave secreta Rails              | obrigatório em produção |
| `DATABASE_USER`     | Usuário PostgreSQL               | postgres   |
| `DATABASE_PASSWORD` | Senha PostgreSQL                 | password   |
| `DATABASE_HOST`     | Host do banco                    | localhost  |

Em desenvolvimento com Docker, essas variáveis já estão definidas no `docker-compose.yml`.

## Internacionalização

Suporte a `en` e `pt`. Locale selecionado via header `Accept-Language`.
