package Sangoku::API::Site {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record';

  use constant MAX => 1;

  has [qw/term game_year
    game_time access unite_flag/]   => (is => 'rw', isa => 'Int', default => 0);
  has [qw/game_month before_start/] => (is => 'rw', isa => 'Int', default => 1);
  has 'start_time'                  => (is => 'rw', isa => 'Int', required => 1);

  sub file_path() { 'etc/record/site.dat' }

  __PACKAGE__->meta->make_immutable();
}

1;
