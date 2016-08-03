# ディレクトリ構成
00_compile.pm
01_jikkoku.pm
model/
db/
api/
service/
web/

harriet/          # Harriet用スクリプト
lib/Test/Jikkoku/ # テスト専用のモジュール群

# 基本構成
use Jikkoku 'test';
use Test::More;
use Test::Jikkoku;  # Data::Dumperのutf8化, dump_yaml関数インポート,Test::Name::FromLine付加

use Test::Exception           # 例外なげるmethodのテスト
use Test::Jikkoku::PostgreSQL # データベースを使ったテスト用
Test::Jikkoku::PostgreSQL->construct();

