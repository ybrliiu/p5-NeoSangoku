package Sangoku::Service::Admin::ResetGame {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Service::Role::Base';

  sub reset_game {
    my ($class, $start_time) = @_;
    $class->delete_data_all();
    $class->init_data_all($start_time);
  }

  sub delete_data_all {
    my ($class) = @_;
    $class->model($_)->delete_all() for qw/Unit Town Country/;
    $class->model('Player')->erase_all();
    $class->model($_)->remove() for qw/MapLog HistoryLog AdminLog/;
  }

  sub init_data_all {
    my ($class, $start_time) = @_;
    $class->model($_)->init() for qw/Country Town Player Country::Position MapLog HistoryLog AdminLog/;
    $class->model('Site')->init($start_time);
  }

  # this method is very dangerous.
  # Only use if you want to erase every data.
  sub erase_game_data_all {
    my ($class) = @_;
    $class->delete_data_all();
    $class->model($_)->remove() for qw/Site/;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
