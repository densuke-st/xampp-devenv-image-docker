#!/bin/sh
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
    # Check if ldd command itself failed  
    # ただし、PHP内蔵のシンボルまで存在しない扱いになるので、"symbol not found"をキーとして除外しておく
    ldd_full_output=$(ldd "${dll}" 2>&1)
    ldd_exit_status=$?
    ldd_full_output=$(echo "${ldd_full_output}" | grep -v "symbol not found")
    # echo "=== debug ldd output ==="
    # echo "${ldd_full_output}"
    # echo "=== end of debug ldd output ==="

    # if [ "${ldd_exit_status}" -ne 0 ]; then
    #     if echo "${ldd_full_output}" | grep -q "not found"; then
    #         echo " Error: Missing dependencies for ${dll} (found 'not found' in ldd output). ldd exit status: ${ldd_exit_status}" >&2
    #     else
    #         echo " Error: ldd command failed for ${dll} (e.g., not a dynamic executable or missing fundamental libs). ldd exit status: ${ldd_exit_status}" >&2
    #     fi
    #     echo "${ldd_full_output}" >&2
    #     exit 1
    # fi
    if echo "${ldd_full_output}" | grep -q "not found"; then
        echo " Error: Missing dependencies for ${dll} (found 'not found' in ldd output, though ldd exited 0)." >&2
        echo "${ldd_full_output}" >&2
        exit 1
    fi
    echo "OK"
done
echo "All PHP extension libraries have their dependencies satisfied."
exit 0