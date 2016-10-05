package Sangoku::API::HistoryLog {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record::Log';

  use overload (
    q{""}    => 'string',
    fallback => 1,
  );

  sub file_path {
    my ($class) = @_;
    $class->DIR_PATH . 'history_log.dat';
  }

  __PACKAGE__->meta->make_immutable();
}

1;
