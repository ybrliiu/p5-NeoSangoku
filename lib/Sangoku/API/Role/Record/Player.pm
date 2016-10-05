package Sangoku::API::Role::Record::Player {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::API::Role::Record' => {
    -alias   => {DIR_PATH => 'ROOT_DIR_PATH'},
    -exclude => 'DIR_PATH',
  };

  requires 'DIR_PATH';

  around 'DIR_PATH' => sub {
    my ($orig, $class) = @_;
    $class->ROOT_DIR_PATH . 'player/' . $class->$orig;
  };

  # ファイルの場所
  sub file_path { 
    my ($class, $id)  = @_;
    return $class->DIR_PATH . "$id.dat";
  }

}

1;
