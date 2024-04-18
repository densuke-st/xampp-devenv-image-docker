FROM php:apache
ARG USER_NAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000
# PHP拡張としてmysqliとzipをインストール
RUN apt-get update && apt-get install -y libzip-dev && docker-php-ext-install mysqli zip
# git環境をインストール
RUN apt-get update && apt-get install -y git unzip
# Python3をインストール、一緒にpipとpipenvもインストール
RUN apt-get install -y python3 python3-pip pipenv
RUN ln -s /usr/bin/python3 /usr/bin/python
# ユーザーを追加
RUN groupadd -g $USER_GID $USER_NAME && \
    useradd -u $USER_UID -g $USER_GID -s /bin/bash -m $USER_NAME
# vscodeユーザーがsudoできるようにする
RUN apt-get install -y sudo && \
    echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER_NAME && \
    chmod 0440 /etc/sudoers.d/$USER_NAME
USER ${USER_NAME}
ENV HOME=/home/${USER_NAME}
ENV PATH=$HOME/.local/bin:$PATH
RUN pip install --user --break-system-packages selenium
