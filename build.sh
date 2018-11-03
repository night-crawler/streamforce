#!/usr/bin/env bash

docker build -t ncrawler/streamforce:latest \
    .

docker-squash ncrawler/streamforce:latest -t ncrawler/streamforce:squashed-latest
