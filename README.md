# embulk-filter-query_string_parse

## これは

* embulk の filter プラグインサンプルです

## Setup

### Require

* Docker
* docker-compose

### docker build

```sh
$ docker-compose build
$ docker-compose up -d
```

### docker コンテナにて

Docker コンテナには `docker exec -t -i embulk bash` でログイン, ログイン後に以下を実行します.

```sh
# plugin のインストール
$ embulk bundle

# 動作確認
$ embulk preview config.cloudfront.xxx.yml --load-path ./plugins

# 実行
$ embulk run config.cloudfront.xxx.yml --load-path ./plugins
```
