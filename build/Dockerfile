FROM php:alpine
ARG USER_NAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
# PHP拡張としてmysqliとzipをインストール
RUN apk add --no-cache libzip-dev bash && docker-php-ext-install mysqli zip
# # git環境をインストール
RUN apk add --no-cache git unzip
# RUN apt-get update && apt-get install -y git unzip
# # Python3をインストール、一緒にpipとpipenvもインストール
RUN apk add --no-cache python3
# RUN apt-get update && apt-get install -y python3 python3-pip pipenv
# # ユーザーを追加
# RUN groupadd -g  $USER_GID $USER_NAME && \
#     useradd -u $USER_UID -g $USER_GID -s /bin/bash -m $USER_NAME
RUN addgroup -g  $USER_GID $USER_NAME && \
    adduser -u $USER_UID -G $USER_NAME -D -s /bin/bash $USER_NAME
# # vscodeユーザーがsudoできるようにする
# RUN apt-get update; apt-get install -y sudo && \
#     echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER_NAME && \
#     chmod 0440 /etc/sudoers.d/$USER_NAME
RUN apk add --no-cache sudo && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER_NAME && \
    chmod 0440 /etc/sudoers.d/$USER_NAME

# # ghコマンドを追加
# RUN mkdir -p -m 755 /etc/apt/keyrings && \
#     curl -sL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
#         tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
#     && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
#     && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
#         tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
#     && apt update && apt install gh -y ; rm -fr /var/cache/apt /var/lib/apt
RUN apk add --no-cache github-cli
RUN apk add --no-cache py3-pip
RUN apk add --no-cache tzdata musl-locales && \
    ln -s /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apk add --no-cache make
RUN apk add --no-cache autoconf build-base linux-headers && \
    pecl install xdebug && \
    apk del -r autoconf build-base linux-headers && \
    docker-php-ext-enable xdebug
RUN cd /usr/local/etc/php; ln -sf php.ini-development php.ini
RUN apk add --no-cache docker-cli docker-cli-buildx
USER ${USER_NAME}
ENV TZ=Asia/Tokyo
ENV LC_ALL=ja_JP.UTF-8
ENV HOME=/home/${USER_NAME}
ENV PATH=$HOME/.local/bin:$PATH
RUN pip install --user --break-system-packages selenium mysql-connector-python sqlalchemy
WORKDIR /var/www/html
ENTRYPOINT [ "/usr/local/bin/php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]
