package Sangoku::Model::IconList {

  use Mouse;
  use Sangoku;

  use constant {
    ICONS_DIR_PATH => '/images/icons/',
    MAX            => 500,
  };

  has 'limit' => (is => 'ro', isa => 'Int', default => 50);

  sub get {
    my ($self, $page) = @_;
    $page //= 0;

    my $offset = $page * $self->limit;
    my @icons = map {
      +{
        no   => $_,
        path => ICONS_DIR_PATH . "$_.gif",
      }
    } $offset .. $offset + $self->limit - 1;
    return \@icons;
  }

  sub get_iter {
    my ($self, $page) = @_;
    my $icons = $self->get($page);

    sub {
      state $count = 0;
      $icons->[$count++];
    };
  }

  sub max_page {
    my ($self) = @_;
    return int(MAX / $self->limit - 0.9);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
