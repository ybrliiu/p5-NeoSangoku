use Sangoku 'test';
use Test::Record;

my $TEST_CLASS = 'Sangoku::Model::Player::ReadLetter';
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
  ok(my $read_letter = $OBJ->get);
  is $read_letter->player, 0;
  
  {
    my $rec = $OBJ->record->open('LOCK_EX');
    my $read_letter = $rec->at(0);
    $read_letter->player(10);
    $rec->close();
  }

  ok($read_letter = $OBJ->get);
  is $read_letter->player, 10;
};

done_testing();
