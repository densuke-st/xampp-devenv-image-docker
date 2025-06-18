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

for dll in *.so; do
    echo -n "Checking dependencies for ${dll}..."
    if ! ldd "${dll}" 2>&1 | grep -q "not found"; then
        echo "OK"
    else
        echo "Error: Missing dependencies for ${dll}."
        exit 1
    fi
done