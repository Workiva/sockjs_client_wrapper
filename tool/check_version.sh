#!/bin/bash

SEMVER_REGEX="^(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)(\-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$"

MASTER_REV=$(git rev-parse origin/master)
CURRENT_REV=$(git rev-parse HEAD)

TAG=$(git name-rev --tags --name-only $(git rev-parse HEAD))
TAG="undefined"

if [[ "$TAG" =~ $SEMVER_REGEX ]]; then
  echo "Tagged Version, no pubspec.yaml version bump needed."
  exit 0
elif [ "$MASTER_REV" == "$CURRENT_REV" ]; then
  echo "Untagged master, no pubspec.yaml version bump needed."
  exit 0
else
  VERSION_DIFF=$(git log -L2,1:pubspec.yaml origin/master.. | grep +version:)
  if [ -n "$VERSION_DIFF" ]; then
    echo "Updated version: $VERSION_DIFF"; exit 0
  else
    echo "Didn't update version"; exit 1
  fi
fi
