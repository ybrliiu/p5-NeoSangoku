use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Record;
use Test::Sangoku::Util qw/prepare_player_model_tests/;

my $TEST_CLASS = 'Sangoku::Model::Country::Members';
load $TEST_CLASS;
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();

prepare_player_model_tests();

subtest 'add&get' => sub {

  my $country_name = '聖櫻学園';
  Sangoku::Model::Country->create({
    name  => $country_name,
    color => 'gray',
  });

  my $player_id = '__risa__';
  Sangoku::Model::Player->create({
    id           => $player_id,
    name         => '篠宮理沙',
    pass         => '12345678',
    icon         => 0,
    town_name    => '開封',
    force        => 1,
    intellect    => 1,
    leadership   => 1,
    popular      => 200,
    loyalty      => 100,
    update_time  => time,
  });
  my $player = Sangoku::Model::Player->get($player_id);

  ok(my $model = $TEST_CLASS->new(name => $country_name));
  ok $model->add($player_id);
  ok(my $members = $model->get);
  is $members->[0]->player_id, $player->id;
};

done_testing();
