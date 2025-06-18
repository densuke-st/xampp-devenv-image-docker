#!/bin/sh
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

for dll in *.so; do
    echo -n "Checking dependencies for ${dll}..."
    ldd_output=$(ldd "${dll}" 2>&1)
    ldd_status=$?

    if [ ${ldd_status} -ne 0 ] || echo "${ldd_output}" | grep -q "not found"; then
        echo "Error: Missing dependencies for ${dll}." >&2
        exit 1
    else
        echo "OK"
    fi
done