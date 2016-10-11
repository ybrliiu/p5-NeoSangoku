package Test::Sangoku::Util {

  use Sangoku 'test';

  use Exporter 'import';
  our @EXPORT_OK = qw/TEST_PLAYER_DATA create_test_player prepare_player_model_tests prepare_country_model_tests/;

  sub TEST_PLAYER_DATA() {
    my $id = 'test_player';
    state $data = {
      player => {
        id   => $id,
        name => 'テスト用プレイヤー',
        pass => 'test_test',
        icon => 0,
        country_name => '無所属',
        town_name    => '成都',
        force        => 100,
        intellect    => 10,
        leadership   => 10,
        popular      => 10,
        loyalty      => 10,
        update_time  => time,
      },
      weapon => {
        player_id => $id,
        power     => 10,
      },
      guard  => {
        player_id => $id,
        power     => 10,
      },
      book   => {
        player_id => $id,
        power     => 10,
      },
    };
  }

  sub create_test_player {
    require Sangoku::Model::Player;
    Sangoku::Model::Player->create(TEST_PLAYER_DATA->{player});
  }

  sub prepare_player_model_tests {
    load "Sangoku::Model::$_" for qw/Country Town Player/;
    "Sangoku::Model::$_"->init() for qw/Country Town/;
    my $klass = 'Sangoku::Model::Player';
    $klass->create($klass->ADMINISTARTOR_DATA->{player});
  }

  sub prepare_country_model_tests {
    my $klass = 'Sangoku::Model::Country';
    load $klass;
    my $neutral_data = $klass->NEUTRAL_DATA;
    $klass->create({
      name  => $neutral_data->{name},
      color => $neutral_data->{gray},
    });
  }
  
}

1;
