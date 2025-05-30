# はじめに

このリポジトリは、とある科目でXAMPPの代替として使用するイメージのビルド部分を担っております。
管理者が設定を変更してコミットすると、

- linux/arm64
- linux/amd64

向けにイメージのリビルドと公開を行います。

# 利用方法

イメージはGitHub Packagesにて公開しています

- [Packages: xampp-devenv](https://github.com/densuke-st/xampp-devenv-image-docker/pkgs/container/xampp-devenv)

たとえばイメージの取得であれば、以下の操作で行えます。

```bash
$ git image pull ghcr.io/densuke/xampp-devenv:latest    # latest
$ git image pull ghcr.io/densuke/xampp-devenv:748507667 # 特定のビルド
```

タグは以下のルールで付与しています。
- 各ビルドに対してビルド時のエポック秒ベースのもの。
    - "エポック秒ベース"-arch も存在していますが、いちいち選んで使うことは無いと思います。
        - amd64
        - arm64
- 最後のビルドにはlatest。
リビルド時点の最新版にはlatestタグを、各ビルドにはエポック秒ベースのタグをつけています。

# どこで使っているの?

こちらです。

- [kd-it/xampp-devenv-template](https://github.com/kd-it/xampp-devenv-template)