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
    validate_values($args => [qw/player_id command_name/]);
    my $model = $class->model('Command');
    $model->input($args);
  }

  sub select {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id command_name current_page numbers/]);
    my $model = $class->model('Command');
    my $next_info = $model->select($args);
    return $next_info;
  }

}

1;
