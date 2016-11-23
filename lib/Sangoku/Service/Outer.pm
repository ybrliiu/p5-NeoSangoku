package Sangoku::Service::Outer {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub player_list {
    my ($class, $country_name) = @_;

    my $countreis = defined $country_name
      ? [$class->model('Country')->get($country_name)]
      : $class->model('Country')->get_all();

    my $players = $class->model('Player')->get_all_joined_to_country_members();

    return {
      countries         => $countreis,
      positions_hash    => $class->model('Country::Position')->get_all_to_hash(),
      players_hash      => $class->model('Player')->to_hash($players),
      towns             => $class->model('Town')->get_all(),
      (map {
        my $class_name = ucfirst $_;
        $_ . 's_hash'   => $class->model("Player::$class_name")->get_all_to_hash()
      } qw/book weapon guard/),
    };
  }

  sub map {
    my ($class) = @_;
    return {
      map_data       => $class->model('Town')->get_all_for_map(),
      countries_hash => $class->model('Country')->get_all_to_hash(),
      history_log    => $class->model('HistoryLog')->get_all(),
      map_log        => $class->model('MapLog')->get_all(),
    };
  }

  sub icon_list {
    my ($class, $page) = @_;
    $page //= 0;

    state $model = $class->model('IconList')->new();

    return {
      icons_iter     => $model->get_iter($page),
      max_page       => $model->max_page,
      current_page   => $page,
      ICONS_DIR_PATH => $model->ICONS_DIR_PATH,
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
