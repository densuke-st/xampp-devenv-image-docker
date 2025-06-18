#!/bin/sh
set -euo pipefail
# PythonのDLLが必要としているライブラリが存在しているかを確認する
# - 各環境のPythonのDLL(*.so)のあるディレクトリを調べて移動する
# - 各DLL(*.so)にlddで確認し、必要なのに発見できないライブラリがあればエラーを出して終了する
# lib_dynloadディレクトリの中にあるファイル達をチェックすればよい
# ただし利用するイメージにより場所が違うので検索すること
LIBDIR=$(python -c 'import sysconfig; print(sysconfig.get_path("platstdlib") + "/lib-dynload")')

if [ -z "$LIBDIR" ]; then
  echo "Error: Unable to determine Python dynamic library directory."
  exit 1
fi

cd "${LIBDIR}" || exit 1

# *.soが全くないのはおかしいので、この時点でたたき落としておく
set -- *.so
if [ "$1" = "*.so" ] || [ $# -eq 0 ]; then
  echo "Error: No Python extension libraries found."
  exit 1
fi

found_any_so_files=false  
for dll_file in *.so; do  
    if ! [ -f "$dll_file" ]; then  
        continue  
    fi  
    found_any_so_files=true  

    echo -n "Checking dependencies for ${dll_file}..."  
    ldd_full_output=$(ldd "${dll_file}" 2>&1)
    ldd_exit_status=$?
    ldd_full_output=$(echo "${ldd_full_output}" | grep -v "symbol not found")

    if ! echo ${ldd_full_output} | grep -q "not found"; then  
        echo " OK"  
    else  
        echo " Error: Missing dependencies for ${dll_file}." >&2  
        echo "${ldd_full_output}" | grep --color=never "not found" >&2  
        exit 1  
    fi  
done  

if ! $found_any_so_files; then
  echo "Error: Glob *.so expanded, but no regular .so files were found to check in ${LIBDIR}." >&2
  exit 1
fi

exit 0
