#!/bin/sh
set -euo pipefail
# PHPのモードがdevになっていることを確認する
# php -iでerror_reportingの値がE_ALLを指す32767稼働かを確認する
REQUIRED_ERROR_REPORTING=32767
CURRENT_ERROR_REPORTING=$(php -r "echo ini_get('error_reporting');")
if [ "$CURRENT_ERROR_REPORTING" != "$REQUIRED_ERROR_REPORTING" ]; then
  echo "Error: error_reporting is not set to $REQUIRED_ERROR_REPORTING. Current error_reporting is $CURRENT_ERROR_REPORTING."
  exit 1
fi
exit 0