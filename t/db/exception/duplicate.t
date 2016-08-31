use Sangoku 'test';
use Test::More;
use Test::Sangoku;
use Test::Exception;

use Sangoku::DB::Exception::Duplicate;
my $TEST_CLASS = 'Sangoku::DB::Exception::Duplicate';

subtest 'throw exception' => sub {
  throws_ok {
    $TEST_CLASS->throw(
      message => 'test_throw',
      sql     => 'TEST SQL',
      reason  => 'test reason',
      bind    => {test => 'てすとばいんど'},
    )
  } qr/test_throw/, 'throw success';
};

subtest 'operation verification' => sub {
  eval {
    $TEST_CLASS->throw(
      message => 'test_throw',
      sql     => 'TEST SQL',
      reason  => 'test reason',
      bind    => {test => 'てすとばいんど'},
    )
  };
  my $e = $@;
  ok $TEST_CLASS->caught($e), 'discriminate error';
  is($e->table_name(), 'unknown. look at SQL.');
};

done_testing;
