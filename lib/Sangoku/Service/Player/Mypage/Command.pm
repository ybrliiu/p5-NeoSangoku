package Sangoku::Service::Player::Mypage::Command {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Sangoku::Util qw/validate_values/;

  sub root {
    my ($class, $player_id) = @_;
    return {
      command => $class->model('Player::Command')->new(id => $player_id)->get_all(),
    };
  }

  sub input {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id command_id/]);
    my $model = $class->model('Command');
    $model->input($args);
  }

  sub choose_option {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id command_id current_page numbers/]);
    my $model = $class->model('Command');
    my $next_info = $model->choose_option($args);
    return $next_info;
  }

}

1;
