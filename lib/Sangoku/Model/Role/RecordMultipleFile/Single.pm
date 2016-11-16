package Sangoku::Model::Role::RecordMultipleFile::Single {

  use Mouse::Role;
  use Sangoku;
  with 'Sangoku::Model::Role::RecordMultipleFile';
  requires 'CLASS';

  use Record::List::Log;

  sub _build_record {
    my ($self) = @_;
    return Record::List->new(
      file => $self->CLASS->file_path($self->id),
      max  => $self->CLASS->MAX,
    );
  }

  sub init {
    my ($self, $__init__) = @_;
    $self->record->make();
    my $record = $self->record->open('LOCK_EX');
    my $obj = $self->CLASS->new();
    $self->$__init__($obj) if $__init__;
    $record->add($obj);
    $record->close();
  }

  sub get {
    my ($self) = @_;
    my $record = $self->record->open();
    return $record->at(0);
  }

}

1;
