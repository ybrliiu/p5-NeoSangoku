use Sangoku 'test';

my $TEST_CLASS = 'Sangoku::API::Command::Role::Base';

lives_ok {
  package Sangoku::API::Command::TestCommand {
    use Mouse;
    use Sangoku;
    has 'name' => (is => 'ro', default => 'テストコマンド');
    with $TEST_CLASS;
    sub execute {}
  }
};

subtest 'new' => sub {
  my $use_class = 'Sangoku::API::Command::TestCommand';
  ok(my $command = $use_class->new);
  is $command->id, 'TestCommand';
  isa_ok $command, $use_class;
  ok $command->can($_) for qw/input execute/;
};

done_testing();
