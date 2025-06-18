#!/bin/sh
# 拡張モジュールのDLLが必要なライブラリを全て持っているかを確認する
LIBPATH=$(php -i 2>/dev/null | grep extension_dir  | awk '{print $3}' | grep ^/)
if [ -z "$LIBPATH" ]; then
  echo "Error: Unable to determine PHP extension directory."
  exit 1
fi
echo "PHP extension directory: $LIBPATH"
cd ${LIBPATH} || exit 1

# *.soのファイルがひとつも無いのはむしろおかしいのでエラーとしてここでたたき落とす
set -- *.so
if [ "$1" = "*.so" ] || [ $# -eq 0 ]; then
  echo "Error: No PHP extension libraries found."
  exit 1
fi

# 拡張モジュールのDLLをチェックする
for dll in *.so; do
    echo -n "Checking dependencies for ${dll}..."
    ldd "${dll}"  2>&1 | grep -q "not found" && exit 1
    echo "OK"
done
echo "All PHP extension libraries have their dependencies satisfied."
exit 0