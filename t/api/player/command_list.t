use Sangoku 'test';
use Test::More;
use Test::Sangoku;

use Sangoku::API::Player::CommandList;
my $class = 'Sangoku::API::Player::CommandList';

subtest 'check' => sub {
  unlike $class->file_path('test'), qr/tmp/;
  ok $class->MAX();
  ok $class->DEFAULT_NAME();
};

subtest 'new' => sub {
  my $command_list = $class->new();
  isa_ok $command_list => $class;
  ok $command_list->is_default_name();
};

subtest 'record_test' => sub {
  require Test::Record;
  my $test = Test::Record->new();
  like $class->file_path('test'), qr/$ENV{TEST_RECORD_TMP_DIR}/;
};

done_testing();
