#!/bin/sh
set -eu
# タイムゾーンが日本になっていることを確認する
TIMEZONE=$(date +%Z)
if [ "$TIMEZONE" != "JST" ]; then
  echo "Error: Timezone is not set to Japan Standard Time (JST). Current timezone is $TIMEZONE."
  exit 1
fi
exit 0