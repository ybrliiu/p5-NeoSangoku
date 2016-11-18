use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

use Sangoku::Model::Player;
use Sangoku::Model::Player::Letter;
use Sangoku::Model::Country;

my $PSQL = Test::Sangoku::PostgreSQL->new();
my $PLAYER_ID = Sangoku::Model::Player->ADMINISTARTOR_DATA->{player}{id};
my $NEUTRAL_DATA = Sangoku::Model::Country->NEUTRAL_DATA;
my $TEST_CLASS = 'Sangoku::Model::Country::Letter';
load $TEST_CLASS;
my $OBJ;

# player のtableなども準備しないといけないので
prepare_player_model_tests();
my $TEST_COUNTRY_NAME2 = 'テスト国家';
Sangoku::Model::Country->create({name => $TEST_COUNTRY_NAME2, color => 'gray'});

subtest 'new' => sub {
  $OBJ = $TEST_CLASS->new(name => $NEUTRAL_DATA->{name});
  isa_ok $OBJ, $TEST_CLASS;
};

subtest 'add, add_sended' => sub {
  my $sender = Sangoku::Model::Player->get($PLAYER_ID);

  ok $OBJ->add({
    sender        => $sender,
    receiver_name => $TEST_COUNTRY_NAME2,
    message       => '手紙テスト',
  });

  ok $OBJ->add({
    sender        => $sender,
    receiver_name => $NEUTRAL_DATA->{name},
    message       => 'テスト',
  });

  ok (my $letter_data = $OBJ->add({
    sender        => $sender,
    receiver_name => $NEUTRAL_DATA->{name},
    message       => 'テスト2',
  }));
  is $letter_data->{id}, 4;

};

subtest 'get_all' => sub {
  ok(my $list = $OBJ->get_all);
  is @$list, 4;
};

subtest 'get' => sub {

  {
    ok(my $list = $OBJ->get);
    is @$list, 3;
    my $letter = $list->[0];
    is $letter->message, 'テスト2';
  }

  {
    ok(my $list = Sangoku::Model::Player::Letter->new(id => $PLAYER_ID)->get());
    is @$list, 3;
    my $letter = $list->[0];
    is $letter->message, 'テスト2';
  }

};

done_testing();
