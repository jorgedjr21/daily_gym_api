bash:
	docker-compose run --rm web bash
start:
	docker-compose up
specs:
	docker-compose run --rm web bundle exec rspec