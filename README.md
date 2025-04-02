## Minecraftのサーバをドメインでプロキシする用のHAProxy

### 概要
このリポジトリではHAProxyを使用して、ドメイン名やサブドメイン名に基づいてマインクラフトサーバーへのトラフィックをルーティングするための設定を提供します。複数のマインクラフトサーバーを単一のポート（25565）で管理することができます。

#### ログ出力機能
このHAProxyの設定では、詳細なログ出力に対応しています。マインクラフトサーバーへの接続や状態をモニタリングするのに役立ちます。

ログ出力の例:
```
haproxy-1  | 2025-04-02T08:02:37+00:00 localhost HAProxy[7]: Connect from 192.168.1.100:56322 to 192.168.1.200:25565 (minecraft/TCP)
haproxy-1  | 2025-04-02T08:02:37+00:00 localhost HAProxy[7]: START: Processing Minecraft handshake
haproxy-1  | 2025-04-02T08:02:37+00:00 localhost HAProxy[7]: PACKET LENGTH: 21
haproxy-1  | 2025-04-02T08:02:37+00:00 localhost HAProxy[7]: SUCCESS: Protocol=758, Host=minecraft.example.com, State=2
```

各ログエントリには以下の情報が含まれます:
- タイムスタンプ
- 接続元IPアドレスとポート、接続先IPアドレスとポート
- マインクラフトハンドシェイクの処理状態
- パケット長
- 成功ステータス（プロトコルバージョン、ホスト名、状態）

**14,15行目**
```
use_backend minecraft1_flg if { var(txn.mc_host) -i -m dom ドメイン名1 }
use_backend minecraft2_flg if { var(txn.mc_host) -i -m dom ドメイン名2 }
```

* `ドメイン名1`, `ドメイン名2` → 接続先のドメイン名またはサブドメイン名を入力します。
* `-i` フラグは大文字小文字を区別しないマッチングを有効にします。
* `-m dom` はドメイン名のマッチングモードを指定します。

例：
- 1つめのドメインの場合：`minecraft.example.com`
- 2つめのドメインの場合：`hypixel.net`

```
use_backend minecraft1_flg if { var(txn.mc_host) -i -m dom minecraft.example.com }
use_backend minecraft2_flg if { var(txn.mc_host) -i -m dom mc.hypixel.net }
```

**18,21行目**
```
backend minecraft1_flg
  server minecraft1_srv サーバ1のIPアドレス

backend minecraft2_flg
  server minecraft2_srv サーバ2のIPアドレス
```

* `サーバ1のIPアドレス`, `サーバ2のIPアドレス` → マインクラフトのサーバのIPアドレスを入力します。ポート番号も指定できます。

例：サーバIPが192.168.100.200でポート番号が25565の場合
```
server minecraft1_srv 192.168.100.200:25565
```

バックエンド設定の例：
```
backend minecraft1_flg
  server minecraft1_srv 192.168.100.100:25565

backend minecraft2_flg
  server minecraft2_srv 192.168.100.200:25565
```

### 注意事項
* サーバーへの接続はTCP経由で行われるため、ファイアウォールの設定を確認してください。
* 複数のバックエンドサーバーを追加する場合は、haproxy.cfgファイル内のbackendセクションを増やしてください。

### 使用方法
1. haproxy.cfgファイルを環境に合わせて編集します。
2. docker-compose.ymlを使用してコンテナを起動します：
   ```
   docker-compose up -d
   ```
3. マインクラフトクライアントから設定したドメイン名でサーバーに接続します。

詳細な設定やLuaスクリプトについては、haproxy_minecraft.luaファイルを参照してください。

### Special Thanks
このプロジェクトで使用されているLuaスクリプトは、以下の作者によって提供された元のコードを基にしています：
- Nathan Poirier: https://gist.github.com/nathan818fr/a078e92604784ad56e84843ebf99e2e5

このスクリプトにより、マインクラフトのハンドシェイクパケットを解析してバックエンドサーバーを選択することが可能になりました。
