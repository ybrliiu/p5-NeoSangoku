package Sangoku::DB::Exception::Duplicate {

  use Sangoku;
  use parent 'Sangoku::DB::Exception';

  use Class::Accessor::Lite new => 0;
  Class::Accessor::Lite->mk_ro_accessors(qw/table_name/);

  use Sangoku::Util qw/validate_keys/;

  sub throw {
    my ($class, %args) = @_;
    validate_keys(\%args => [qw/message reason sql bind/]);

    $class->_throw(\%args, sub {
      my ($self) = @_;
      # Sangoku::Model::{ ... }::TABLE_NAME()
      $self->{table_name} = $self->{package}->can('TABLE_NAME') ? $self->{package}->TABLE_NAME() : 'unknown. look at SQL.';
    });
  }

}

1;
