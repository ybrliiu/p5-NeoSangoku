package Sangoku::Model::Role::Config {

  use Sangoku;
  use Mouse::Role;
  requires qw/FILE/;

  use Sangoku::Util qw/load_config/;

  sub config {
    my ($class) = @_;
    state $config = load_config('data/' . $class->FILE . '.conf')->{$class->FILE};
  }

  sub to_hash {
    my ($class) = @_;
    my %hash = map { $_->{name} => $_ } @{$class->config};
    return \%hash;
  }

}

1;
