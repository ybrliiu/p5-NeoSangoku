# ディレクトリ構成
00_compile.pm
01_jikkoku.pm
model/
db/
api/
service/
web/

lib/Test/Jikkoku/    # テスト専用のモジュール群

# 基本構成
use Jikkoku 'test';
use Test::More;
use Test::Jikkoku;  # Data::Dumperのutf8化, dump_yaml関数インポート

use Test::Exception           # 例外なげるmethodのテスト
use Test::Jikkoku::PostgreSQL # データベースを使ったテスト用

