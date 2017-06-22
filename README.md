EMCC13.2
========

Oracle Enterprise Manager Cloud Control 13c Release 2 Plug-in Update 1 (13.2.0.0) for Linux x86-64 の簡易セットアップ。

## 事前準備

`sample.env`を環境に応じて編集し、`.env`というファイル名で保存する。
ここで、MEDIAはダウンロードしたファイルの格納ディレクトリ、STAGINGは作業用ディレクトリを示す。
どちらのディレクトリもoracleユーザーが参照できるようにしておくこと。

## ダウンロード

[Oracle Enterprise Manager Downloads](http://www.oracle.com/technetwork/oem/enterprise-manager/downloads/index.html)から下記のソフトウェアをダウンロードし、`.env`でMEDIAに指定したディレクトリに配置。

* Oracle Enterprise Manager Cloud Control 13c Release 2 Plug-in Update 1 (13.2.0.0) for Linux x86-64
    + em13200p1_linux64.bin
    + em13200p1_linux64-2.zip
    + em13200p1_linux64-3.zip
    + em13200p1_linux64-4.zip
    + em13200p1_linux64-5.zip
    + em13200p1_linux64-6.zip
    + em13200p1_linux64-7.zip
* Oracle Database 12c Release 1 (12.1.0.2.0) for Linux x86-64
    + linuxamd64_12102_database_1of2.zip
    + linuxamd64_12102_database_2of2.zip
* Database Template (with EM 13.2.0.0 repository pre-configured) for Installing Oracle Enterprise Manager Cloud Control 13c Release 2 (13.2.0.0)
    + 12.1.0.2.0_Database_Template_for_EM13_2_0_0_0_Linux_x64.zip

## セットアップ

下記のスクリプトを順次実行。

```
./1_check_requirements.sh
./2_os.sh
./3_install_database.sh
./4_create_database.sh
./5_install_oms.sh
```

## 動作確認

ブラウザで https://(ホスト名):7803/em にアクセスする。

起動、停止は`start.sh`、`stop.sh`で可能。

## Author ##

[Shinichi Akiyama](https://github.com/shakiyam)

## License ##

[MIT License](http://www.opensource.org/licenses/mit-license.php)
