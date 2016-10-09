package Sangoku::Service::Player::MyPage {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub root {
    my ($class, $id) = @_;

    return {
      player => $class->model('Player')->get($id),
      towns  => $class->model('Town')->get_all(),
    };
  }

  __PACKAGE__->meta->make_immutable();
}

1;
