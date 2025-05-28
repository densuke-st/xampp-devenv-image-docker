#FROM php:apache
FROM ghcr.io/astral-sh/uv:python3.13-bookworm AS uv-source
# ---
FROM php:8.3-apache AS build
ARG USER_NAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

# PHPまわりの設定
WORKDIR /usr/local
RUN <<EOT
    # ビルド時のスレッド数を「CPU数*2+1」に設定
    export MAKEFLAGS="-j$(($(nproc) * 2 + 1))" &&
    # ビルドに必要なライブラリを追加
    apt-get update &&
    apt-get install -y libzip-dev && 
    # ビルド前のタイムスタンプを記録しておく
    touch /tmp/now &&
    # 必要な拡張をインストール(mysqli, pdo_mysql, zip)
    docker-php-ext-install mysqli pdo_mysql zip &&
    apt-get purge --auto-remove --purge -y libzip-dev &&
    # クリーンナップ
    apt-get clean &&
    rm -fr /var/lib/apt/lists/* 
EOT

# ビルド後の変化のあったファイルをアーカイブする、タイミングは/tmp/now以降
RUN tar cvzf /exts.tar.gz $( find lib/php etc/php -type f -newer /tmp/now )
RUN tar tvzf /exts.tar.gz

FROM php:8.3-apache
ARG USER_NAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000


ENV LANG=ja_JP.UTF-8
ENV LC_ALL=ja_JP.UTF-8

# ツール類のインストール(git, python, locales)
# Python 3.13より古いものがPython-minimalで入ると思いますが、プロジェクト側で3.13以上にしているので
# あくまでuvが最低限のPythonを要求するための対応です。
RUN <<EOT
    apt-get update && 
    apt-get install -y git unzip python3-minimal locales sudo &&
    apt-get clean &&
    rm -fr /var/lib/apt/lists/* &&
    # OSレベルのロケール、タイムゾーンも日本向けに調整
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime &&
    echo "Asia/Tokyo" > /etc/timezone &&
    sed -i -e 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen &&
    locale-gen ja_JP.UTF-8
EOT

# exts.tar.gzからPHP拡張を復元、その上でPHPの設定を調整
COPY --from=build /exts.tar.gz /tmp/exts.tar.gz
WORKDIR /usr/local
RUN <<EOT
    # exts.tar.gzからPHP拡張を復元
    tar xvfz /tmp/exts.tar.gz && 
    rm -vf /tmp/exts.tar.gz &&
    # PHPの設定を開発モードにする
    cd /usr/local/etc/php && 
    ln -sf php.ini-development php.ini &&
    # タイムゾーンを設定
    echo "date.timezone = Asia/Tokyo" >> php.ini
EOT

# ユーザーを追加し、sudo権限を付与
RUN <<EOT
    groupadd -g $USER_GID $USER_NAME &&
    useradd -l -u $USER_UID -g $USER_GID -s /bin/bash -m $USER_NAME &&
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER_NAME &&
    chmod 0440 /etc/sudoers.d/$USER_NAME
EOT

# uvコマンド
COPY --from=uv-source /usr/local/bin/uv /usr/local/bin/uvx /usr/local/bin/

USER ${USER_NAME}
ENV HOME=/home/${USER_NAME}
ENV PATH=$HOME/.local/bin:$PATH
WORKDIR  ${HOME}