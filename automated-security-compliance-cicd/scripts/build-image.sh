#!/usr/bin/env bash
set -euo pipefail
IMAGE_NAME="${IMAGE_NAME:-devsecops-demo}"
IMAGE_TAG="${IMAGE_TAG:-local}"
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" ./app
