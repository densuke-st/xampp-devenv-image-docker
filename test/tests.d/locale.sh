#!/bin/sh
set -eu
# ロケールが日本になっていることを確認する
# - LC_ALLがja_JP.UTF-8になっていることを確認する
REQUIRED_LOCALE="ja_JP.UTF-8"
CURRENT_LOCALE=$(locale | grep LC_ALL | awk -F= '{print $2}' | tr -d '"')
if [ "$CURRENT_LOCALE" != "$REQUIRED_LOCALE" ]; then
  echo "Error: LC_ALL is not set to $REQUIRED_LOCALE. Current LC_ALL is $CURRENT_LOCALE."
  exit 1
fi
exit 0