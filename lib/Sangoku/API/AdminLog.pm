package Sangoku::API::AdminLog {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record::Log';

  use overload (
    q{""}    => 'string',
    fallback => 1,
  );

  sub file_path() { 'etc/record/admin_log.dat' }

  __PACKAGE__->meta->make_immutable();
}

1;
