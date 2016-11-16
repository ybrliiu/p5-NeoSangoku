package Sangoku::Model::Role::RecordSingleFile {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::Record';

  use Record::List;

  sub record {
    my ($class) = @_;

    state $record = {};
    return $record->{$class->CLASS} if exists $record->{$class->CLASS};

    $record->{$class->CLASS} = Record::List->new(
      file => $class->CLASS->file_path(),
      max  => $class->CLASS->MAX(),
    );
  }

  sub get {
    my ($class, $num) = @_;
    return $class->record->open->get($num);
  }

  sub get_all {
    my ($class) = @_;
    return $class->record->open->data();
  }

  sub remove {
    my ($class) = @_;
    $class->record->remove();
  }

}

1;
