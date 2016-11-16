package Sangoku::Model::Role::RecordSingleFile::Log {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::RecordSingleFile';

  use Record::List;

  sub init {
    my ($class) = @_;
    $class->record->make();
  }

  sub add {
    my ($class, $str) = @_;
    my $log    = $class->CLASS->new($str);
    my $record = $class->record->open('LOCK_EX');
    $record->add($log);
    $record->close();
  }

}

1;
