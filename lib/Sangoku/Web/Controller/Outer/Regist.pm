package Sangoku::Web::Controller::Outer::Regist {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub root {
    my ($self) = @_;

    my $result = $self->service->root();

    $self->stash(%$result);
    $self->flash_error();
    $self->render_fill_error();
  }

  sub regist {
    my ($self) = @_;

    my $param = $self->req->params->to_hash();
    # checkbox が選択されていない場合、undefになってserviceを呼び出せなくなるのを防ぐ
    $param->{confirm_rule} //= 0;
    my $error = $self->service->regist($param);

    if ($error->has_error) {
      $self->flash_error($error);
      $self->redirect_to('/outer/regist');
    } else {
      $self->redirect_to('/outer/regist/complete-regist');
    }

  }

}

1;
