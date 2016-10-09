package Sangoku::Web::Controller::Root {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub root {
    my ($self) = @_;
    my $result = $self->service->root();
    $self->flash_error();
    $self->stash(%$result);
    $self->render_fill_error();
  }

}

1;
