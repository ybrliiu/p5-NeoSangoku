package Sangoku::API::Player::CommandList {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record';

  use constant {
    MAX          => 15, # コマンド最大件数
    DEFAULT_NAME => '-',
  };

  has 'name'    => (is => 'rw', isa => 'Str', default => DEFAULT_NAME);
  has 'command' => (is => 'rw', isa => 'ArrayRef', default => sub { [] });

  # ファイルの場所
  sub file_path { 
    my ($class, $id)  = @_;
    return "etc/record/player/command_list/$id.dat";
  }

  sub set {
    my ($self, $args) = @_;
    $self->name($args->{name}) if $args->{name};
    $self->command($args->{command}) if $args->{command};
  }

  sub is_default_name {
    my ($self) = @_;
    return $self->name() eq DEFAULT_NAME;
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;
