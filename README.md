# Dockerfile of Elasticsearch for Raspberry Pi 2

Run elasticsearch 7.x on a Raspberry Pi 2 in docker.

Successfully tested and running on the following setup:

* Raspberry Pi 2 Model B v1.1	1GB	a21041
* Raspbian Stretch (10.2)
* docker-ce 5:19.03.5\~3-0\~raspbian-buster
* Linux pthagonal 4.19.75-v7+ #1270 SMP Tue Sep 24 18:45:11 BST 2019 armv7l GNU/Linux

## Setup

Use the `build.sh` script to create the docker image.

Check the `run.sh` script on how to start the container. Update the path to the directoy where you want to keep your elasticsearch data.
