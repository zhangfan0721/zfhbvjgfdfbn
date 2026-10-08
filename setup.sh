#!/usr/bin/env bash
set -euo pipefail

echo "=== ABK NoMount Module ==="
echo "KERNEL_ROOT=$KERNEL_ROOT"

if [ -z "${KERNEL_ROOT:-}" ]; then
    echo "ERROR: KERNEL_ROOT is not set"
    exit 1
fi

TMP_DIR="${GITHUB_WORKSPACE}/nomount"

rm -rf "$TMP_DIR"

git clone --depth=1 \
    https://github.com/maxsteeel/nomount.git \
    "$TMP_DIR"

if [ ! -f "$TMP_DIR/kernel/setup.sh" ]; then
    echo "ERROR: NoMount setup.sh not found"
    exit 1
fi

cd "$TMP_DIR/kernel"

bash ./setup.sh

echo "=== NoMount integration finished ==="