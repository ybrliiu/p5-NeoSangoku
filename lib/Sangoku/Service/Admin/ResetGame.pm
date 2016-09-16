package Sangoku::Service::Admin::ResetGame {

  use Sangoku;

  use Sangoku::Util qw/load_child_module/;
  load_child_module('Sangoku::Model');

  sub reset_game {
    my ($class, $start_time) = @_;
    $class->delete_data_all();
    $class->init_data_all($start_time);
  }

  sub delete_data_all {
    my ($class) = @_;
    "Sangoku::Model::$_"->delete_all() for qw/Unit Player Town Country/;
    "Sangoku::Model::Player::$_"->remove_all() for qw/Command CommandLog CommandList/;
    "Sangoku::Model::$_"->remove() for qw/MapLog HistoryLog AdminLog/;
  }

  sub init_data_all {
    my ($class, $start_time) = @_;
    "Sangoku::Model::$_"->init() for qw/Country Town Player MapLog HistoryLog AdminLog/;
    Sangoku::Model::Site->init($start_time);
  }

}

1;
