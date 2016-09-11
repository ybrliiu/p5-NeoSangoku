package Sangoku::Model::AdminLog {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::RecordSingle::Log';

  use Sangoku::API::AdminLog;

  use constant CLASS => 'Sangoku::API::AdminLog';

  __PACKAGE__->meta->make_immutable();
}

1;
