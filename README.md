# はじめに

このリポジトリは、とある科目でXAMPP代わりに使うイメージのビルド部分を担っております。
管理者が設定を変更してコミットすると、

- linux/arm64
- linux/amd64

向けにイメージのリビルドと公開を行います。

# 利用方法

イメージはpackagesにて公開しています

- [Packages: xampp-devenv](https://github.com/densuke-st/xampp-devenv-image-docker/pkgs/container/xampp-devenv)

リビルド時点の最新版にはlatestタグを、各ビルドにはエポック秒ベースのタグをつけています。

# どこで使っているの?

こちらです。

- [kd-it/xampp-devenv-template](https://github.com/kd-it/xampp-devenv-template)