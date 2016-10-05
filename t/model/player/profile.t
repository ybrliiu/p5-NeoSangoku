use Sangoku 'test';
use Test::Record;

my $TEST_CLASS = 'Sangoku::Model::Player::Profile';
load $TEST_CLASS;
my $OBJ;

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(id => 'liiu');
  isa_ok $OBJ, $TEST_CLASS;
};

done_testing();
