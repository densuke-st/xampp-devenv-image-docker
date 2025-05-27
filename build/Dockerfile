FROM php:8.3-apache
ARG USER_NAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
# PHP拡張としてmysqliとzipをインストール
RUN apt-get update && apt-get install -y libzip-dev && docker-php-ext-install mysqli zip
# git環境をインストール
RUN apt-get update && apt-get install -y git unzip
# Python3をインストール、一緒にpipとpipenvもインストール
RUN apt-get update && apt-get install -y python3 python3-pip pipenv
RUN ln -s /usr/bin/python3 /usr/bin/python
# PHPを開発モードに設定
RUN cd /usr/local/etc/php && ln -sf php.ini-development php.ini
# ユーザーを追加
RUN groupadd -g $USER_GID $USER_NAME && \
    useradd -u $USER_UID -g $USER_GID -s /bin/bash -m $USER_NAME
# vscodeユーザーがsudoできるようにする
RUN apt-get update; apt-get install -y sudo && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER_NAME && \
    chmod 0440 /etc/sudoers.d/$USER_NAME
# ghコマンドを追加
RUN mkdir -p -m 755 /etc/apt/keyrings && \
    curl -sL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
        tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
        tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update && apt install gh -y ; rm -fr /var/cache/apt /var/lib/apt

USER ${USER_NAME}
ENV HOME=/home/${USER_NAME}
ENV PATH=$HOME/.local/bin:$PATH
RUN pip install --user --break-system-packages selenium mysql-connector-python sqlalchemy
