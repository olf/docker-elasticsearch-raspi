#!/usr/bin/env bash

docker build -t elasticsearch:latest -t elasticsearch:openjdk8 -t elasticsearch:$(date +%Y%m%d-%H%M%S) .

