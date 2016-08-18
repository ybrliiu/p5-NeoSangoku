package Sangoku::Model::Role::Record {

  use Sangoku;
  use Mouse::Role;
  requires qw/CLASS _build_record init/;

  has 'id'     => (is => 'ro', isa => 'Str', required => 1);
  has 'record' => (is => 'ro', lazy => 1, builder => '_build_record');

  sub get {
    my ($self, $num) = @_;
    return $self->record->open->get($num);
  }

  sub get_all {
    my ($self) = @_;
    return $self->record->open->data();
  }

  sub remove {
    my ($self) = @_;
    $self->record->remove();
  }

}

1;
