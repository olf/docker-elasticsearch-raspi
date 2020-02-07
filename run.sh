#!/usr/bin/env bash

docker run -d -v /home/olf/work/esindex:/opt/elasticsearch/data --name es -p 9200:9200 --rm --cpu-shares 4096 elasticsearch:latest

