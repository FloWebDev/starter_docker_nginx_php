default: help

PROJECT_NAME := BASIC
IDU := $(shell id -u)
IDG := $(shell id -g)
CONTAINERS := $(shell docker ps -a -q)

.PHONY: help build-up nginx-sh php-fpm-sh mysql-sh serve

#
### General
#

## build, create and start containers
build-up:
	docker-compose build --build-arg UID=$(IDU) --build-arg GID=$(IDG)
	docker-compose up -d
	echo "docker-compose up with USER: $(IDU)(uid) GROUP: $(IDG)(gid)"

## stop and remove resources
down:
	docker-compose down

## access to nginx docker container
nginx-sh:
	docker-compose exec web bash

## access to php-fpm docker container
php-fpm-sh:
	docker-compose exec -u www-data php-fpm /bin/sh

## access to mysql docker container
mysql-sh:
	docker-compose exec mysql bash

## launch the web app server
serve:
	docker-compose exec php-fpm /usr/local/bin/php /var/www/html/basic/yii serve 0.0.0.0:8080

## remove all Docker containers and images
remove-all:
	docker rm -f $(CONTAINERS) && docker image prune -a

# COLORS
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)
TARGET_MAX_CHAR_NUM=25

#
### Utils
#

## Show the nice helper with the targets and their description
help:
	@echo "= Project $(PROJECT_NAME) make helper ="
	@awk '/^### (.*)/ { \
		print ""; \
		for (i = 2; i <= NF; i++) {\
			printf "%s ", $$i; \
		} \
		print ""; \
	} \
	/^#### (.*)/ { \
		printf "  "; \
		for (i = 2; i <= NF; i++) { \
			printf "%s ", $$i; \
		} \
		print ""; \
	} \
	/^[a-zA-Z\-\_0-9\/]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "    ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} { lastLine = $$0 }' $(MAKEFILE_LIST)
