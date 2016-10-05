use Sangoku 'test';

use Sangoku::Util qw/daytime/;

use Sangoku::API::Player::CommandLog;
my $TEST_CLASS = 'Sangoku::API::Player::CommandLog';

subtest 'check' => sub {
  ok $TEST_CLASS->MAX();
  # このテストはちょっとまずい(パスの確認をもっと良くする方法があれば。。)
  is $TEST_CLASS->file_path('id'), 'etc/record/player/command_log/id.dat';
};

subtest 'new' => sub {
  my $log = $TEST_CLASS->new('テストログ');
  isa_ok $log, $TEST_CLASS;
  like $log, qr/テストログ/;
  like $log, qr/@{[ daytime() ]}/;
};

done_testing();
