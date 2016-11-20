package Test::Sangoku::Util {

  use Sangoku;
  use Module::Load;

  use Exporter 'import';
  our @EXPORT_OK = qw/TEST_PLAYER_DATA create_test_player
    prepare_player_model_tests prepare_country_model_tests prepare_service_tests/;

  sub TEST_PLAYER_DATA() {
    state $id = 'test_player';
    state $equipment_status = {
      player_id => $id,
      power     => 10,
    };
    state $data = {
      player => {
        id   => $id,
        name => 'テスト用プレイヤー',
        pass => 'test_test',
        icon => 0,
        town_name    => '成都',
        force        => 100,
        intellect    => 10,
        leadership   => 10,
        popular      => 10,
        loyalty      => 10,
        update_time  => time,
      },
      country_name => '無所属',
      profile => '',
      weapon  => $equipment_status,
      guard   => $equipment_status,
      book    => $equipment_status,
    };
  }

  sub create_test_player {
    require Sangoku::Model::Player;
    Sangoku::Model::Player->create(TEST_PLAYER_DATA->{player});
    # player 関係データのうち、所属国は非常によく使うので
    Sangoku::Model::Country::Members->new(name => TEST_PLAYER_DATA->{country_name})->add(TEST_PLAYER_DATA->{player}{id});
  }

  sub prepare_player_model_tests {
    load "Sangoku::Model::$_" for qw/Country Town Player/;
    "Sangoku::Model::$_"->init() for qw/Country Town/;
    my $klass = 'Sangoku::Model::Player';
    my $player_data = $klass->ADMINISTARTOR_DATA;
    $klass->create($player_data->{player});
    # player 関係データのうち、所属国は非常によく使うので
    Sangoku::Model::Country::Members->new(name => $player_data->{country_name})->add($player_data->{player}{id});
  }

  sub prepare_country_model_tests {
    my $klass = 'Sangoku::Model::Country';
    load $klass;
    $klass->init();
  }

  # Test::Record を同時に使用すること
  sub prepare_service_tests {
    my $init_class = "Sangoku::Service::Admin::ResetGame";
    load $init_class;
    $init_class->init_data_all("2016年1月1日0時");
    
    create_test_player();
  }
  
}

1;
