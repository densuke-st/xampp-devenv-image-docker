#!/bin/sh
set -euo pipefail
# Pythonのインストールを確認
# - pythonコマンドで呼びだせるか
# - python3コマンドで呼びだせるか
# - バージョンが3.11以上か
REQUIRED_VERSION="3.11"
if ! command -v python3 > /dev/null 2>&1; then
  echo "Error: python3 command not found."
  exit 1
fi
if ! command -v python > /dev/null 2>&1; then
  echo "Error: python command not found."
  exit 1
fi
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
  echo "Error: Python version must be at least $REQUIRED_VERSION(${PYTHON_VERSION})."
  exit 1
fi