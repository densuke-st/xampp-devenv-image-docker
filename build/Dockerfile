FROM php:alpine
ARG USER_NAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
# PHP拡張としてmysqli/pdo_mysqlとzipをインストール
RUN apk add --no-cache libzip-dev bash && MAKEFLAGS="-j$(nproc)" docker-php-ext-install mysqli pdo_mysql zip
# git環境をインストール
RUN apk add --no-cache git unzip
# Python環境をインストール
RUN apk add --no-cache python3 py3-pip
# ユーザーを追加
RUN addgroup -g  $USER_GID $USER_NAME && \
    adduser -u $USER_UID -G $USER_NAME -D -s /bin/bash $USER_NAME
# vscodeユーザーがsudoできるようにする
RUN apk add --no-cache sudo && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER_NAME && \
    chmod 0440 /etc/sudoers.d/$USER_NAME

# ghコマンドを追加
RUN apk add --no-cache github-cli

# [WIP]ロケールの設定、日本語ロケールを有効化
RUN apk add --no-cache tzdata musl-locales && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# xdebugのインストール
RUN apk add --no-cache make autoconf build-base linux-headers && \
    pecl install xdebug && \
    apk del -r autoconf build-base linux-headers && \
    docker-php-ext-enable xdebug
# php.iniの設定(開発用)
RUN cd /usr/local/etc/php; ln -sf php.ini-development php.ini
# composerの持ち込み
COPY --from=composer/composer /usr/bin/composer /usr/bin/composer

# # alpine環境下で最新版のdocker cliをインストール
# # 現在は不要なのでコメントアウト
# ARG DOCKER_ENGINE_URL="https://download.docker.com/linux/static/stable"
# RUN set -x; \
#     URL="${DOCKER_ENGINE_URL}/`uname -m`"; \
#     ARC=$(curl -sL $URL | egrep -o -e "docker-[0-9.-]+.tgz" |tail -n1) && \
#     curl -sL $URL/$ARC | tar xvz && \
#     cd docker; install -m 0755 docker /usr/local/bin/

# CLIアクセス用にmysql-clientをインストール
RUN apk add --no-cache mysql-client mariadb-connector-c-dev

# 開発用ユーザーに切り替えて、適宜環境変数をセット
USER ${USER_NAME}
ENV TZ=Asia/Tokyo
ENV LC_ALL=ja_JP.UTF-8
ENV HOME=/home/${USER_NAME}
ENV PATH=$HOME/.local/bin:$PATH
RUN pip install --user --break-system-packages selenium mysql-connector-python sqlalchemy
WORKDIR /var/www/html
ENTRYPOINT [ "/usr/local/bin/php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]
