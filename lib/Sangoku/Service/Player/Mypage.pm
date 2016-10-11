package Sangoku::Service::Player::Mypage {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Sangoku::Util qw/validate_values/;

  sub root {
    my ($class, $player_id) = @_;

    state $config = {
      LOG => {
        COMMAND_LOG => 6,
        MAP_LOG     => 6,
      },
      LETTER => {
        COUNTRY => 15,
        INVITE  => 5,
        PLAYER  => 10,
        TOWN    => 5,
        UNIT    => 5,
      },
    };

    my $player         = $class->model('Player')->get($player_id);
    my $unit           = $player->unit;
    my $countreis_hash = $class->model('Country')->get_all_to_hash();
    my $country        = $player->country($countreis_hash);
    my $towns          = $class->model('Town')->get_all();
    my $town           = $player->town;
    my $letter = {
      player  => $player->letter->get($config->{LETTER}{PLAYER}),
      unit    => $player->is_delong_unit ? $unit->letter->get($config->{LETTER}{UNIT}) : [],
      invite  => $player->invite->get($config->{LETTER}{INVITE}),
      country => $country->letter->get($config->{LETTER}{COUNTRY}),
      town    => $town->letter->get($config->{LETTER}{TOWN}),
    };

    return {
      player         => $player,
      command_log    => $player->command_log->get($config->{LOG}{COMMAND_LOG}),
      countries_hash => $countreis_hash,
      country        => $country,
      unit           => $unit,
      towns          => $towns,
      map_data       => $class->model('Town')->get_all_for_map($towns),
      town           => $player->town,
      site           => $class->model('Site')->get(),
      map_log        => $class->model('MapLog')->get($config->{LOG}{MAP_LOG}),
      view_config    => $config,
      letter         => $letter,
    };
  }

  sub input_letter {
    my ($class, $args) = @_;
    validate_values($args => [qw/type sender_name sender_icon
      sender_town_name sender_country_name receiver_name message/]);

    state $type_to_class = {
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
