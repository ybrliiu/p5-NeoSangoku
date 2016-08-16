package Sangoku::API::Player::Command {

  use Sangoku;
  use Mouse;
  with 'Sangoku::API::Role::Record';

  use constant MAX => 126; # コマンド最大件数

  has [qw/id detail/] => (is => 'ro', isa => 'Str', required => 1);
  has 'options'       => (is => 'ro', isa => 'HashRef');
  
  # ファイルの場所
  sub file_path { 
    my ($class, $id)  = @_;
    return "etc/record/player/command/$id.dat";
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;
