package Sangoku::API::Site {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record';

  use Sangoku::Util qw/load_config/;

  use constant MAX => 1;

  has [qw/term game_time
    access unite_flag/] => (is => 'rw', isa => 'Int', default => 0);
  has [qw/game_month
    before_start/]      => (is => 'rw', isa => 'Int', default => 1);
  has 'game_year'  => (is => 'rw', isa => 'Int', builder => '_build_game_year');
  has 'start_time' => (is => 'rw', isa => 'Int', required => 1);

  sub _build_game_year {
    my $game_year = load_config('etc/config/site.conf')->{site}{start_year};
    return $game_year;
  }

  sub file_path {
    my ($class) = @_;
    $class->DIR_PATH . 'site.dat'
  }

  __PACKAGE__->meta->make_immutable();
}

1;
