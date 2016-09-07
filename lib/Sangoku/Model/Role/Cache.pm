package Sangoku::Model::Role::Cache {

  use Sangoku;
  use Mouse::Role;
  requires qw/KEY/;

  use Cache::SharedMemoryBackend;

  sub cache {
    my ($class) = @_;

    state $cache;
    return $cache if defined $cache;

    $cache = Cache::SharedMemoryBackend->new();
  }

}

1;
