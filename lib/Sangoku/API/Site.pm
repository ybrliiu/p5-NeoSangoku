package Sangoku::API::Site {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record';

  use Sangoku::Util qw/load_config/;

  use constant {
    MAX        => 1,
    START_YEAR => load_config('site.conf')->{site}{start_year},
  };

  has [qw/term game_time
    access unite_flag/] => (is => 'rw', isa => 'Int', default => 0);
  has [qw/game_month
    before_start/]      => (is => 'rw', isa => 'Int', default => 1);
  has 'game_year'  => (is => 'rw', isa => 'Int', default => START_YEAR);
  has 'start_time' => (is => 'rw', isa => 'Int', required => 1);

  sub passed_year {
    my ($self) = @_;
    return $self->game_year - START_YEAR;
  }

  sub file_path {
    my ($class) = @_;
    return $class->DIR_PATH . 'site.dat';
  }

  __PACKAGE__->meta->make_immutable();
}

1;
