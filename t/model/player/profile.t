use Sangoku 'test';
use Test::Record;

my $TEST_CLASS = 'Sangoku::Model::Player::Profile';
load $TEST_CLASS;

my $TR = Test::Record->new();
my $OBJ;
my $PLAYER_ID = 'test_player';

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(id => $PLAYER_ID);
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'init' => sub {
  ok $OBJ->init();
  dies_ok { $OBJ->init() };
};

subtest 'get' => sub {
  ok(my $profile = $OBJ->get);
  {
    my $rec = $OBJ->record->open('LOCK_EX');
    my $profile = $OBJ->get();
    $profile->message('my profile message is ... ');
    $rec->close();
  }
  like $OBJ->get->message, qr/my profile/;
};

done_testing();
