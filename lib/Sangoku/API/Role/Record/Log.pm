package Sangoku::API::Role::Record::Log {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::API::Role::Record';
  requires qw/file_path/;

  use Sangoku::Util qw/daytime/;

  use constant MAX => 500;

  has 'log' => (is => 'ro', isa => 'Str', required => 1);

  around 'BUILDARGS' => sub {
    my ($orig, $class, @args) = @_;

    if (@args == 1 && !ref $args[0]) {
      return $class->$orig(log => $args[0]);
    } else {
      return $class->$orig(@args);
    }
  };

  sub BUILD {
    my ($self) = @_;
    $self->{log} = $self->log . '(' . daytime() . ')';
  }

  # $self->log のエイリアス(overloadのため)
  sub string { shift->{log} }
  
}

1;
