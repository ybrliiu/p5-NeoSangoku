package Sangoku::Web::Controller::Outer {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub icon_list {
    my ($self) = @_;

    my $page = $self->param('page');
    my $result = $self->service->icon_list($page);
    $self->stash(%$result);

    $self->render();
  }

}

1;
