.PHONY: install build test publish release clean lint check-licenses deep-clean

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

install: install-python install-hooks install-node

install-python:
	poetry install

install-node:
	npm ci

install-hooks:
	poetry run pre-commit install --install-hooks --overwrite

build:
	npm run build

lint: lint-node lint-python lint-githubactions

lint-node:
	npm run lint

lint-python:
	poetry run flake8 scripts/*.py --config .flake8

lint-githubactions:
	actionlint

test:
	npm run test

clean:
	rm -rf coverage lib

deep-clean: clean
	rm -rf .venv
	find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +

check-licenses: check-licenses-node check-licenses-python

check-licenses-node:
	npm run check-licenses
	
check-licenses-python:
	scripts/check_python_licenses.sh
