use Sangoku 'test';
use Test::More; # テストモジュール
use Test::Sangoku;
use Test::Exception; # 例外を伴うテスト

use Sangoku::DB::Exception;
my $class = 'Sangoku::DB::Exception';

subtest 'throw exception' => sub {
  throws_ok {
    $class->throw(
      message => 'test_throw',
      sql     => 'TEST SQL',
      reason  => 'test reason',
      bind    => {test => 'てすとばいんど'},
    )
  } qr/test_throw/, 'throw success';
};

subtest 'operation verification' => sub {
  eval {
    $class->throw(
      message => 'test_throw',
      sql     => 'TEST SQL',
      reason  => 'test reason',
      bind    => {test => 'てすとばいんど'},
    )
  };
  my $e = $@;
  ok $class->caught($e), 'discriminate error';
  diag $e;
};

done_testing;
