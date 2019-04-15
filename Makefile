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
	docker-compose run --rm terraform-utils terraform init examples

PHONY: validate
validate:
	docker-compose run --rm terraform-utils terraform validate examples