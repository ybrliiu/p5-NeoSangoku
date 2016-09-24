use Sangoku 'test';
use Test::More;
use Test::Exception;
use Test::Sangoku;
use Test::Record;
use Test::Sangoku::PostgreSQL;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

package Sangoku::Example {
  use Mouse;
  with 'Sangoku::Service::Role::Base';
}

my $TEST_CLASS = 'Sangoku::Example';
my $PSQL = Test::Sangoku::PostgreSQL->new();

prepare_player_model_tests();

subtest 'model' => sub {
  is $TEST_CLASS->model('Player::CommandLog'), 'Sangoku::Model::Player::CommandLog';
};

subtest 'txn' => sub {
  my $model = $TEST_CLASS->model('Player');
  ok(my $txn = $TEST_CLASS->txn);
  my $player = $model->get($model->ADMINISTARTOR_DATA->{player}{id});
  $player->update({name => '一般プレイヤー'});
  ok $txn->commit();

  my $update_player = $player->refetch();
  is $update_player->name, '一般プレイヤー';
};

subtest 'txn_rollback' => sub {
  my $model = $TEST_CLASS->model('Player');
  my $txn = $TEST_CLASS->txn();
  my $player = $model->get($model->ADMINISTARTOR_DATA->{player}{id});
  $player->update({name => 'hoge'});
  ok $txn->rollback();

  my $update_player = $player->refetch();
  is $update_player->name, '一般プレイヤー';
};

done_testing();

