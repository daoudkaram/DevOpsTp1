#!/bin/bash

set -e #exit if command fails

docker build -t dev-app -f 4-dev-app.dockerfile .

docker run --rm -p 3000:3000 dev-app
