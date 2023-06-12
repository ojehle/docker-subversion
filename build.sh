#!/bin/bash
docker build -t murks/docker-subversion:latest .
docker push murks/docker-subversion:latest
