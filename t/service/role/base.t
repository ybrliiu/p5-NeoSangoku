use Sangoku 'test';
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

  ok(my $txn = $TEST_CLASS->txn);

  my $model = $TEST_CLASS->model('Player');
  my $player = $model->get($model->ADMINISTARTOR_DATA->{player}{id});
  $player->update({name => '一般プレイヤー'});

  my $country = $TEST_CLASS->model('Country')->get( $model->ADMINISTARTOR_DATA->{player}{country_name} );
  $country->update({color => 'red'});

  ok $txn->commit();

  my $update_player = $player->refetch();
  is $update_player->name, '一般プレイヤー';

  my $update_country = $country->refetch();
  is $update_country->color, 'red';

};

subtest 'txn_rollback' => sub {

  my $txn = $TEST_CLASS->txn();

  my $model = $TEST_CLASS->model('Player');
  my $player = $model->get($model->ADMINISTARTOR_DATA->{player}{id});
  $player->update({name => 'hoge'});

  my $country = $TEST_CLASS->model('Country')->get( $model->ADMINISTARTOR_DATA->{player}{country_name} );
  $country->update({color => 'blue'});

  ok $txn->rollback();

  my $update_player = $player->refetch();
  is $update_player->name, '一般プレイヤー';

  my $update_country = $country->refetch();
  is $update_country->color , 'red';

};

done_testing();

