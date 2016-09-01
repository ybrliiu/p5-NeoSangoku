use Sangoku 'test';
use Test::More;
use Test::Sangoku;

use Sangoku::API::Player::Command;
my $TEST_CLASS = 'Sangoku::API::Player::Command';

subtest 'check' => sub {
  unlike $TEST_CLASS->file_path('test'), qr/tmp/;
  ok $TEST_CLASS->MAX();
};

subtest 'new' => sub {
  my $command = $TEST_CLASS->new(
    id     => 'Test',
    detail => 'てすと',
  );
  isa_ok $command, $TEST_CLASS;
};

subtest 'record_test' => sub {
  require Test::Record;
  my $test = Test::Record->new();
  like $TEST_CLASS->file_path('test'), qr/$ENV{TEST_RECORD_TMP_DIR}/;
};

done_testing();
