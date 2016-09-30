use Sangoku 'test';

use Sangoku::API::Player::CommandList;
my $TEST_CLASS = 'Sangoku::API::Player::CommandList';

subtest 'check' => sub {
  unlike $TEST_CLASS->file_path('test'), qr/tmp/;
  ok $TEST_CLASS->MAX();
  ok $TEST_CLASS->DEFAULT_NAME();
};

subtest 'new' => sub {
  my $command_list = $TEST_CLASS->new();
  isa_ok $command_list, $TEST_CLASS;
  ok $command_list->is_default_name();
};

done_testing();
