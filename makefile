build:
	docker compose build
bash:
	docker compose run --rm daily_gym_api bash
start:
	docker compose up
specs:
	docker compose run --rm daily_gym_api bundle exec rspec