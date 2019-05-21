PHONY: docs
docs:
	docker-compose run --rm terraform-utils terraform-docs markdown table .
	@echo "This does not automatically update README.md. You need to manually copy and paste to the required sections :("

PHONY: format
format:
	docker-compose run --rm terraform-utils terraform fmt .

PHONY: formatCheck
formatCheck:
	docker-compose run --rm terraform-utils terraform fmt -check -diff .

PHONY: init
init:
	docker-compose run --rm terraform-utils terraform init tests/with_kiam
	docker-compose run --rm terraform-utils terraform init tests/without_kiam

PHONY: validate
validate:
	docker-compose run --rm terraform-utils terraform validate tests/with_kiam
	docker-compose run --rm terraform-utils terraform validate tests/without_kiam
