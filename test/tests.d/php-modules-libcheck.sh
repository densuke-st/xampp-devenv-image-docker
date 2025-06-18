#!/bin/sh
set -eu
# 拡張モジュールのDLLが必要なライブラリを全て持っているかを確認する
LIBPATH=$(php -r "echo ini_get('extension_dir');" 2>/dev/null)
if [ -z "$LIBPATH" ]; then
  echo "Error: Unable to determine PHP extension directory."
  exit 1
fi
echo "PHP extension directory: $LIBPATH"
cd "${LIBPATH}" || exit 1

# *.soのファイルがひとつも無いのはむしろおかしいのでエラーとしてここでたたき落とす
set -- *.so
if [ "$1" = "*.so" ] || [ $# -eq 0 ]; then
  echo "Error: No PHP extension libraries found."
  exit 1
fi

# 拡張モジュールのDLLをチェックする
for dll in *.so; do
    echo -n "Checking dependencies for ${dll}..."
    set +e
    ldd_full_output=$(ldd "${dll}" 2>&1)
    ldd_exit_status=$?
    ldd_full_output=$(echo "${ldd_full_output}" | grep -v "symbol not found")
    set -e

    if echo "${ldd_full_output}" | grep -q "not found"; then
        echo " Error: Missing dependencies for ${dll} (found 'not found' in ldd output, though ldd exited 0)." >&2
        echo "${ldd_full_output}" >&2
        exit 1
    fi
    echo "OK"
done
echo "All PHP extension libraries have their dependencies satisfied."
exit 0
