package Sangoku::API::Command::Insert {

  use Mouse;
  use Sangoku;
  use Carp qw/croak/;

  has 'name' => (is => 'ro', isa => 'Str', default => '空白を入れる');

  with 'Sangoku::API::Command::Base';

  sub input {
  }

  sub execute { croak 'Insert Command cant execute!!' }

  __PACKAGE__->meta->make_immutable();
}

1;
