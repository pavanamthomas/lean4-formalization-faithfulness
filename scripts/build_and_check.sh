#!/usr/bin/env bash
set -euo pipefail

./scripts/check_no_sorry.sh
lake update
lake exe cache get
lake build

echo "Build and placeholder checks completed."
