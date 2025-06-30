#!/bin/bash

docker-compose up -d


cd infrahub

poetry config virtualenvs.create true
poetry install --no-interaction --no-ansi

poetry run invoke start