## マインクラフトのサーバをサブドメインでプロキシする用のHAProxyのDOCKERファイルです。

### 変更箇所
haproxy.cfg

**11,12行目**<br>
{ payload(5,サブドメイン名の文字数) -m sub サブドメイン名 }
* necraftのバージョンが1.8の場合、5 → 4　へ変更する。1.8以降のバージョンの場合、5のまま。
* ドメイン名の文字数 →　サブドメイン名の文字数を数字で入力する。例:サブドメイン名がminecraft1の場合、10
* ドメイン名 → サブドメイン名を入力する。 例:サブドメイン名がminecraft1の場合、minecraft1

例：サブドメイン名がminecraft1の場合<br>
{ payload(5,10-m sub minecraft1 }

<br>

**15,17行目**
server minecraft1_srv サーバ1のIPアドレス
* サーバnのIPアドレス → マインクラフトのサーバのIPアドレスを入力する。ただし、IPアドレス:ポート番号　でポートを指定することができる。

例:サーバIPが192.168.100.200でポート番号が55555の場合<br>
server minecraft1_srv 192.168.100.200:55555<br>
https://github.com/MuNeNICK/docker-haproxy-minecraft/blob/8df0e553d1af22f1c177e24141ffb994320918d5/haproxy.cfg#L1-L18
