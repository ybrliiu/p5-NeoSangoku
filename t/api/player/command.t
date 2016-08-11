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
  $ENV{TEST_RECORD} = 1;
  like $class->file_path('test'), qr/tmp/;
};

done_testing();
