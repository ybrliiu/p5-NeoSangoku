package Sangoku::Web::Controller::Outer::Regist {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub root {
    my ($self) = @_;

    $self->render();
  }

}

1;
