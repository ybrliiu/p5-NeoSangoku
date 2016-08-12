package Sangoku::DB::Exception::Duplicate {

  use Sangoku;
  use parent 'Sangoku::DB::Exception';

  use Carp qw/confess/;
  use Class::Accessor::Lite new => 0;
  Class::Accessor::Lite->mk_ro_accessors(qw/table_name/);

  use Sangoku::Util qw/validate_keys/;

  sub throw {
    my ($class, %args) = @_;
    validate_keys(\%args => [qw/message reason sql bind/]);

    ($args{package}, $args{file}, $args{line}) = caller(3);
    ($args{call_package}, $args{call_file}, $args{call_line}, $args{call_sub}) = caller(4);

    # Sangoku::Model::{ ... }::TABLE_NAME()
    $args{table_name} = "$args{package}"->TABLE_NAME();

    eval { confess 'start trace' };
    $args{trace} = $@;

    die $class->new(%args);
  }

}

1;
