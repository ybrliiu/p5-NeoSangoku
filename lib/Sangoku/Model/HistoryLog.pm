package Sangoku::Model::HistoryLog {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::RecordSingleFile::Log';

  use Sangoku::API::HistoryLog;

  use constant CLASS => 'Sangoku::API::HistoryLog';

  __PACKAGE__->meta->make_immutable();
}

1;
