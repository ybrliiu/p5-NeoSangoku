package Sangoku::Service::Player::Country {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Sangoku::Util qw/validate_values/;

  sub root {
    my ($class, $player_id) = @_;
    my $player       = $class->model('Player')->get_joined_to_country_members($player_id);
    my $players      = $class->model('Player')->search_joined_to_country_members(country_name => $player->country_name);
    my $players_hash = $class->model('Player')->to_hash($players);
    my $country      = $player->country;
    my $towns        = $class->model('Town')->search(country_name => $player->country_name);
    return {
      player       => $player,
      players      => $players,
      players_hash => $players_hash,
      country      => $country,
      towns        => $towns,
    };
  }

  sub member {
    my ($class, $player_id) = @_;
    my $player  = $class->model('Player')->get_joined_to_country_members($player_id);
    my $country = $player->country;
    my $players = $country->players;
    return {
      player  => $player,
      players => $players,
      country => $country,
      ( map {
        my $model_name = 'Player::' . ucfirst $_;
        my $list = $class->model( $model_name )->search_joined_to_country_members(country_name => $player->country_name);
        $_ . 's_hash' => $class->model($model_name)->to_hash($list);
      } @{ $player->EQUIPMENT_LIST }, 'soldier' ),
    };
  }
  
}

1;
