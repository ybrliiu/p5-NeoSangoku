use Sangoku 'test';
use Test::More;
use Test::Sangoku;

use Sangoku::Util qw/daytime/;

use Sangoku::API::Player::CommandLog;
my $class = 'Sangoku::API::Player::CommandLog';

subtest 'check' => sub {
  ok $class->MAX();
  ok $class->file_path('id');
};

subtest 'new' => sub {
  my $log = $class->new('テストログ');
  isa_ok $log => $class;
  like $log, qr/テストログ/;
  like $log, qr/@{[ daytime() ]}/;
};

done_testing();
