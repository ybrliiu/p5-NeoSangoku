package Sangoku::Model::Country::ConferenceThread {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  __PACKAGE__->meta->make_immutable();
}

1;
