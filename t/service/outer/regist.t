use Sangoku 'test';
use Test::Sangoku::PostgreSQL;
use Test::Record;
use Test::Sangoku::Util qw/TEST_PLAYER_DATA prepare_service_tests/;

my $TEST_CLASS = 'Sangoku::Service::Outer::Regist';
load $TEST_CLASS;
my $PSQL = Test::Sangoku::PostgreSQL->new();
my $TR = Test::Record->new();
prepare_service_tests();

subtest 'build_country' => sub {

  my $builder_id = 'builder';
  my $build_country_name = 'NEW COUNTRY';
  ok my $error = $TEST_CLASS->regist({
    name => '建国者',
    icon => 100,
    town => '開封',
    id   => $builder_id,
    pass => 'builder_pass',
    (map { $_ => 40 } qw/force intellect leadership popular loyalty/),
    profile => 'プロフィール！！',
    confirm_rule  => 1,
    country_name  => $build_country_name,
    country_color => 'red',
  });
  ok !$error->has_error;

  subtest 'regist_player' => sub {

    ok my $error = $TEST_CLASS->regist({
      name => '仕官者',
      icon => 100,
      town => '開封',
      id   => 'belong',
      pass => 'password',
      (map { $_ => 40 } qw/force intellect leadership popular loyalty/),
      profile => 'プロフィール！！',
      confirm_rule  => 1,
    });
    ok !$error->has_error;

    ok my $error = $TEST_CLASS->regist({
      name => '仕官者2',
      icon => 100,
      town => '開封',
      id   => $builder_id,
      pass => 'pass',
      (map { $_ => 100 } qw/force intellect leadership popular loyalty/),
      profile => 'プロフィール！！',
      confirm_rule  => 1,
      country_name  => $build_country_name,
      country_color => 'red',
    });
    ok $error->has_error;
    is $error->get_error_message(ability => 'sum'), '能力の合計値は160になるようにしてください！';
    is $error->get_error_message(id => 'already_exist'), 'そのIDは既に使用されています。';
    is $error->get_error_message(pass => 'LENGTH'), 'パスワードは6文字以上16文字以下で入力してください。';
    is $error->get_error_message(town => 'cant_establish'), 'その都市は既に他の国が支配しています。';
    is $error->get_error_message(country_name => 'already_exist'), 'その国名は既に使用されています。';

  };

};

done_testing();
