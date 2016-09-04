package Sangoku::Model::Country::Law {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'country_conference_law';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

  sub get {
  }

  sub add {
  }

  sub delete {
  }

  __PACKAGE__->meta->make_immutable();
}

1;
