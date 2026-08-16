#!/usr/bin/env bash
set -euo pipefail

if grep -RInE --include='*.lean' '\b(sorry|admit)\b' FormalizationFaithfulness FormalizationFaithfulness.lean; then
  echo "ERROR: found sorry/admit in Lean sources." >&2
  exit 1
fi

echo "No sorry/admit placeholders found."
