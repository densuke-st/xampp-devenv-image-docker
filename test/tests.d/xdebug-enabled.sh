#!/bin/sh
# PHPでXdebugが有効になっているなら、
# php -iの出力にxdebugキーが含まれるはずです
set -eu
php -i | grep -q 'xdebug'
