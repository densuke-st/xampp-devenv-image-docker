#!/bin/sh
set -eu
# sudo入ってますか? sudoコマンドがパス上に存在するかを確認する。
if ! command -v sudo > /dev/null 2>&1; then
  echo "Error: sudo command not found."
  exit 1
fi
exit 0
