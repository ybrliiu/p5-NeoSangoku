package Sangoku::Web::Controller::Root {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  use Sangoku::Service::Root;

  sub root {
    my ($self) = @_;

    my $result = Sangoku::Service::Root->root();
    $self->stash(%$result);

    $self->render();
  }

}

1;
