#!/bin/sh
# PHPモジュールの確認
# Dockerfile上で入っているべきモジュールの一覧
REQUIRED_MODULES="mysqli pdo_mysql zip"

# 実際にインストールされているモジュールの一覧
INSTALLED_MODULES=$(php -m)

# 必要なモジュールがインストールされているか確認
for module in $REQUIRED_MODULES; do
  echo "$INSTALLED_MODULES" | grep -q "$module"
  if [ $? -ne 0 ]; then
    echo "Missing PHP module: $module"
    exit 1
  fi
done

echo "All required PHP modules are installed."