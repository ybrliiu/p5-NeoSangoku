package Sangoku::Web::Controller::Outer {

  use Sangoku;
  use Mojo::Base 'Mojolicious::Controller';

  sub player_list {
    my ($self) = @_;
    my $country_name = $self->param('country_name');
    my $result = $self->service->player_list($country_name);
    $self->stash(%$result);
    $self->render();
  }

  sub map {
    my ($self) = @_;
    my $result = $self->service->map();
    $self->stash(%$result);
    $self->render();
  }

  sub icon_list {
    my ($self) = @_;

    my $page = $self->param('page');
    my $result = $self->service->icon_list($page);
    $self->stash(%$result);

    $self->render();
  }

}

1;
