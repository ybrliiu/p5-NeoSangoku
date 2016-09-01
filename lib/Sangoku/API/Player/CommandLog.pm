package Sangoku::API::Player::CommandLog {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record';

  use overload (
    fallback => 1,
    q{""}    => 'string',
  );
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
    $self->{log} = "$self->{log}(@{[ daytime() ]})";
  }

  # ファイルの場所
  sub file_path { 
    my ($class, $id)  = @_;
    return "etc/record/player/command_log/$id.dat";
  }

  # $self->log のエイリアス(overloadのため)
  sub string { shift->{log} }
  
  __PACKAGE__->meta->make_immutable();
}

1;
