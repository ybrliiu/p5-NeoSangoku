package Sangoku::DB::Row::Unit {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  sub letter {
    my ($self) = @_;
    return $self->model('Unit::Letter')->new(
      id   => $self->id,
      name => $self->name,
    );
  }

}

1;
