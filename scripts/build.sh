#!/usr/bin/env bash

set -euo pipefail

profile="dev"

if [[ "${1:-}" == "release" || "${1:-}" == "dev" || "${1:-}" == "debug" ]]; then
  profile="$1"
  shift
fi

if [[ "${1:-}" == "--" ]]; then
  shift
fi

scripts/ensure-pebble-sdk.sh
mise run prepare-package -- "$profile"
node scripts/prepare-fixture.js
pebble build "$@"

if [[ "$profile" == "dev" ]]; then
  pbw_path="$(ls -t build/*.pbw | head -n 1)"
  cp "$pbw_path" build/forecaswatch2-dev.pbw
fi

if [[ "$profile" == "debug" ]]; then
  pbw_path="$(ls -t build/*.pbw | head -n 1)"
  cp "$pbw_path" build/YaForecasWatch2-debug.pbw
fi
