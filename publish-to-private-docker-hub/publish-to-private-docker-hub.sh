#!/bin/bash
set -e

echo "========================================="
echo " Docker Publish Script"
echo "========================================="
echo ""

# Defaults
DEFAULT_REGISTRY="registry.abc.de"
DEFAULT_USER="user"
DEFAULT_IMAGE="appx"

print_usage() {
  echo ""
  echo "Usage:"
  echo "  ./publish-to-private-docker-hub.sh <registry> <user> <image> <version>"
  echo ""
  echo "Example:"
  echo "  ./publish-to-private-docker-hub.sh registry.abc.de user appx 1.2.3"
  echo ""
}

# Inputs
REGISTRY=${1:-$DEFAULT_REGISTRY}
USER=${2:-$DEFAULT_USER}
IMAGE=${3:-$DEFAULT_IMAGE}
VERSION=$4

echo "Checking parameters..."
echo ""

# Registry
if [ -z "$1" ]; then
  echo "[INFO] Registry not set, using default '$DEFAULT_REGISTRY'"
else
  echo "[OK] Registry set to '$REGISTRY'"
fi

# User
if [ -z "$2" ]; then
  echo "[INFO] User not set, using default '$DEFAULT_USER'"
else
  echo "[OK] User set to '$USER'"
fi

# Image
if [ -z "$3" ]; then
  echo "[INFO] Image not set, using default '$DEFAULT_IMAGE'"
else
  echo "[OK] Image set to '$IMAGE'"
fi

# Version required
if [ -z "$VERSION" ]; then
  echo "[ERROR] Version is required!"
  print_usage
  exit 1
else
  echo "[OK] Version set to '$VERSION'"
fi

echo ""
echo "Final configuration:"
echo "  Registry: $REGISTRY"
echo "  User    : $USER"
echo "  Image   : $IMAGE"
echo "  Version : $VERSION"
echo ""

FULL_IMAGE="$REGISTRY/$USER/$IMAGE"

# 🔥 CONFIRMATION BEFORE LOGIN
echo "-----------------------------------------"
read -p "Proceed with docker login and push? (y/n): " CONFIRM
echo "-----------------------------------------"

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
  echo "Aborted by user."
  exit 0
fi

echo ""
echo "Logging into registry..."
docker login "$REGISTRY"

echo "Building image..."
docker build -t "$FULL_IMAGE:$VERSION" -t "$FULL_IMAGE:latest" .

echo "Pushing image..."
docker push "$FULL_IMAGE" --all-tags

echo ""
echo "DONE ✔"