package Jikkoku::DB {

  use Jikkoku;
  use parent 'Teng';

  __PACKAGE__->load_plugin('Count');
}

1;
