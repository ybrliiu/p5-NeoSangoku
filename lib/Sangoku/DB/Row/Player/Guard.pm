package Sangoku::DB::Row::Player::Guard {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';
  with 'Sangoku::DB::Row::Role::Player::Equipment';

  __PACKAGE__->meta->make_immutable();
}

1;
