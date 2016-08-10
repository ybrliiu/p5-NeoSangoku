package Sangoku::API::Player::Command {

  use Sangoku;
  use Mouse;

  use constant max => 126; # コマンド最大件数

  has [qw/id detail/] => (is => 'ro', isa => 'Str');
  has 'options' => (is => 'ro', isa => 'HashRef');
  
  # ファイルの場所
  sub file_path { 
    my ($class, $id)  = @_;
    return "etc/record/list/command/command/$id.dat";
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;
