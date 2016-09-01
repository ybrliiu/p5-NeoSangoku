# ディレクトリ構成
```
00_compile.pm
01_sangoku.pm
model/
db/
api/
service/
web/

harriet/          # Harriet用スクリプト
lib/Test/Sangoku/ # テスト専用のモジュール群
```

# 基本的な書き方
``` perl
use Sangoku 'test';
use Test::More;
use Test::Sangoku;             # Data::Dumperのutf8化, dump_yaml関数インポート,Test::Name::FromLine付加
use Test::Exception;           # 例外なげるmethodのテスト
use Test::Sangoku::PostgreSQL; # データベースを使ったテスト用
use Test::Record;              # Record.pm使ったテスト用

use Sangoku::TestClass;
my $TEST_CLASS = 'Sangoku::TestClass';      # テストするモジュール

my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

subtest 'first test' => sub {
  ok 1;
  ...
};

...

done_testing();

```
