package Sangoku::Model::Role::RecordSingle::Log {

  use Sangoku;
  use Mouse::Role;
  requires qw/CLASS/;

  use Record::List::Log;

  sub record {
    my ($class) = @_;
    state $record = Record::List::Log->new(
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

  sub add {
    my ($class, $str) = @_;
    my $log    = $class->CLASS->new($str);
    my $record = $class->record->open('LOCK_EX');
    $record->add($log);
    $record->close();
  }

  sub remove {
    my ($class) = @_;
    $class->record->remove();
  }

  sub init {
    my ($class) = @_;

    eval { $class->record->make() };
    if ($@) {
      my $record = $class->record->open('LOCK_EX');
      $record->data([]);
      $record->close();
    }

  }

}

1;
