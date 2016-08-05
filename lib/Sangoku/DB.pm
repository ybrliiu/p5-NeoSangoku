package Sangoku::DB {

  use Sangoku;
  use parent 'Teng';

  __PACKAGE__->load_plugin('Count');
}

1;
