package Sangoku::API::Player::Command {

  use Sangoku;
  use Mouse;

  has [qw/id detail/] => (is => 'ro', isa => 'Str');
  has 'options' => (is => 'ro', isa => 'HashRef');
  
  # ファイルの場所
  sub file_path { 
    my ($class, $id)  = @_;
    return "etc/record/list/command/command/$id.dat";
  }
  
  # コマンド最大数
  sub max() { 126 }

  __PACKAGE__->meta->make_immutable();
}

1;
