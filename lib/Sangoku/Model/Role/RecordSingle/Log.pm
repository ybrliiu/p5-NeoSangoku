package Sangoku::Model::Role::RecordSingle::Log {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::RecordSingle';

  use Record::List;

  sub init {
    my ($class) = @_;

    eval { $class->record->make() };
    if ($@) {
      my $record = $class->record->open('LOCK_EX');
      $record->data([]);
      $record->close();
    }

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
