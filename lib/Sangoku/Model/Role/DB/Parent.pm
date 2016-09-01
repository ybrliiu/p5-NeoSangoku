package Sangoku::Model::Role::DB::Parent {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::DB';
  requires qw/regist erase/;

}

1;
