package Sangoku::Model::MapLog {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::RecordSingleFile::Log';

  use Sangoku::API::MapLog;

  use constant CLASS => 'Sangoku::API::MapLog';

  __PACKAGE__->meta->make_immutable();
}

1;
