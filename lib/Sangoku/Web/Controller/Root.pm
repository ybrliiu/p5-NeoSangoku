package Sangoku::Web::Controller::Root {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub root {
    my ($self) = @_;
    my $result = $self->service->root();
    $self->stash(%$result);
    $self->flash_error();
    $self->render_fill_error();
  }

}

1;
