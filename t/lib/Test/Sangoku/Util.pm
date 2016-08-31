package Test::Sangoku::Util {

  use Sangoku;

  use Exporter 'import';
  our @EXPORT_OK = qw/prepare_player_model_tests/;

  sub prepare_player_model_tests {
    eval "require Sangoku::Model::$_" for qw/Country Town Player/;
    "Sangoku::Model::$_"->init() for qw/Country Town/;
    my $klass = 'Sangoku::Model::Player';
    $klass->create($klass->ADMINISTARTOR_DATA->{player});
  }
  
}

1;
