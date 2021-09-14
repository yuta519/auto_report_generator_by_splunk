# Splunk を利用したレポート自動生成ツール
- 本リポジトリでは、PaloAlto PA シリーズのトラフィックログをパースし、アプリに関するデータを DB Connect 分析を行う
- インフラでは、docker を利用し PostgreSQL と Splunk(free) をコンテナ環境に構築
- PostgreSQL コンテナでは、対象のトラフィックログを取得し、フィールドのパース、テーブルのインサートを実行する
- Splunk コンテナでは、 PostgreSQL で格納するデータを DB Connect を利用して解析する

## セットアップ方法

### .env ファイルの準備 (未対応)
- .env.sample ファイルをコピーして .env を作成する


### docker コンテナの起動(後者の起動方法は試せていない)
- docker compose up
or
- docker-compose up --build
- docker-compose run -d


### 起動したコンテナ&サービスへのログイン
- Splunk GUI
  - Access (admin gui)[http://localhost:8000/]
  - login with user=admin and password=password which you put above

- Splunk コンテナへのログイン
  ``` 
  docker exec -it splunk /bin/bash 
  ```

- PostgreSQL コンテナへのログイン
  ```
  docker exec -it postgresql /bin/sh 
  ```

- PostgreSQL container CLI
  - 上記のコンテナにログイン後に以下を実行
  ```
  psql -h localhost - p 5432 - U postgresql -d agrex(default password is `postgres`)
  ```

### PostgreSQLコンテナでサンプルデータを挿入
- docker exec -it postgresql /bin/sh 
- cd /usr/local/postgres
- sh parse_trafficlogs.sh pa_trafficlogs_sample.csv (実行完了に数分かかると思います)


### Splunk DB Connect のセットアップ
- Splunk から PostgreSQL を利用するにあたり Splunk DB Connect というツールを利用する
- 本ツールを以下手順でセットアップする
  1. Splunk GUI にログインする
  2. ログイン後、左ペインにある「Splunk DB Connect」を選択
  3. 遷移先でチュートリアルに進むので、こちらはスキップする
  4. 「Configuration」>「Settings」に遷移し「JRE Installation Path(JAVA_HOME)」などの情報が表示されることを確認
  5. 上の手順「4」にて、右上に表示される「Save」を選択、エラーが出ず、無事に再起動できることを確認する
  6. 「Configuration」>「Databases」> 「Identities」に遷移し、右上の 「New Identity」を選択
  7. 遷移先で以下の情報を入力し、設定を保存する
    - Identity Name: PostgreSQL
    - Username: postgres
    - Password: postgres 
  8. 「Configuration」>「Databases」> 「Connections」に遷移し、「New Connection」を選択する
  9. 遷移先で以下の情報を入力し、設定を保存する(上手く接続できれば、保存時にエラーなく保存が完了する)
    - Connection Name: PostgreSQL
    - Identity : PostgreSQL
    - Connection Type: PostgreSQL(選択)
    - Timezon: Tokyo
    - Host: {dockerをホストするOSのIPアドレス or postgresql コンテナのIPアドレス}
    - Port: 5432
    - Default Database: agrex

### Splunk DB Connect で利用する dbxquery のためのセキュリティリスク勧告の抑制
- docs
  - https://docs.splunk.com/Documentation/Splunk/8.2.2/Security/SPLsafeguards?ref=hk
- 手順
  - docker exec -it splunk /bin/bash
  - sudo -s
  - chmod 644 /opt/splunk/etc/system/default/web.conf
  - vi /opt/splunk/etc/system/default/web.conf
    # ファイル内の "enable_risky_command_check" を検索
    # 既存の値が true だと思うので、これを false に書き換え、ファイルを保存する
  - chmod 444 /opt/splunk/etc/system/default/web.conf
  - /opt/splunk/bin/splunk restart


### Splunk DB Connect を利用してデータ解析
- 以下の手順で Splunk コンテナから PostgreSQL コンテナのログを検索する 
  1. Splunk GUI にログインする
  2. ログイン後、左ペインにある「Splunk DB Connect」を選択
  3. 「Data Lab」>「SQL Explorer」へ遷移し、左ペインにて以下の設定
    - Connection: PostgreSQL
    - Catalog: agrex
    - Schema: Public
    - Table: app_report
  4. 右上の「Run」を実行しデータが見えることを確認する


### アグレックスアプリの確認 
  1. Splunk GUI にログインする
  2. ログイン後、左ペインにある「アグレックス」を選択
  3. ダッシュボードタブから任意のダッシュボードを選択することで、可視化したグラフを確認可能


## PaloAlto Knowledge page
  - 
  https://live.paloaltonetworks.com/t5/%E3%83%8A%E3%83%AC%E3%83%83%E3%82%B8%E3%83%89%E3%82%AD%E3%83%A5%E3%83%A1%E3%83%B3%E3%83%88/pan-db-category-list-japanese/ta-p/61944