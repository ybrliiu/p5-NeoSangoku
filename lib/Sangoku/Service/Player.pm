package Sangoku::Service::Player {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  sub auth {
    my ($class, $id, $pass) = @_;
    my $validator = $class->validator({id => $id, pass => $pass});

    $validator->check(
      id   => ['NOT_NULL'],
      pass => ['NOT_NULL'],
    );

    my $player = $class->model('Player')->get($id);
    if (defined $player) {
      $validator->set_error(pass => 'equal')
        unless $player->check_pass($pass);
    } else {
      $validator->set_error_and_message(id => (not_find => 'IDが正しくありません！'))
        unless $validator->is_error('id');
    }

    $class->model('LoginList')->update_login_list($player)
      unless $validator->has_error();

    return $validator;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
