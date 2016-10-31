package Sangoku::Role::Config {

  use Mouse::Role;
  use Sangoku;

  use Sangoku::Util qw/load_config/;

  sub config {
    my ($file) = @_;
    state $config = {};
    $config = { %$config, %{ load_config $file } } if defined $file;
    return $config;
  }

}

1;
