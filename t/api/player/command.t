use Sangoku 'test';
use Test::More;
use Test::Sangoku;

use Sangoku::API::Player::Command;
my $class = 'Sangoku::API::Player::Command';

subtest 'check' => sub {
  unlike $class->file_path('test'), qr/tmp/;
  ok $class->max();
};

subtest 'record_test' => sub {
  require Test::Record;
  my $test = Test::Record->new();
  like $class->file_path('test'), qr/$ENV{TEST_RECORD_TMP_DIR}/;
};

done_testing();
