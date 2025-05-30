# はじめに

このリポジトリは、とある科目でXAMPPの代替として使用するイメージのビルド部分を担っております。
2025年度の場合では、以下の科目が該当しています。
- 『Webアプリケーション開発』
- 『システム開発演習』
- Dockerイメージ作りのノウハウという観点では『アプリケーション・サーバー構築』

このリポジトリにおいて、管理者が設定を変更してコミットすると、

- linux/arm64
- linux/amd64

向けにイメージのリビルドと公開を行います。

# 利用方法

イメージはGitHub Packagesにて公開しています

- [Packages: xampp-devenv](https://github.com/densuke-st/xampp-devenv-image-docker/pkgs/container/xampp-devenv)

たとえばイメージの取得であれば、以下の操作で行えます。

```bash
$ docker image pull ghcr.io/densuke-st/xampp-devenv:latest    # latest
$ docker image pull ghcr.io/densuke-st/xampp-devenv:748507667 # 特定のビルド
```

タグは以下のルールで付与しています。

- 各ビルドに対してビルド時の**エポック秒ベースのタイムスタンプ**(例: 1748507667)を使用しています。
    - "エポック秒ベース-arch" も存在していますが、いちいち選んで使うことは無いと思います。
        - amd64
        - arm64
- 最新のビルドにはlatestも付与されています(通常のDockerの利用に対応)。


# どこで使っているの?

こちらです。

- [kd-it/xampp-devenv-template](https://github.com/kd-it/xampp-devenv-template)