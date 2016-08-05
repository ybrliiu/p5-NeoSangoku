package Sangoku::Model::Player {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'player';

  sub init {
    my ($class) = @_;
    $class->delete_all();
    $class->db->do_insert(TABLE_NAME() => {
      id   => 'administrator',
      name => '管理人',
      pass => 'password',
      icon => 0,
      country_name => '無所属',
      town_name    => '開封',
      force        => 10,
      intellect    => 10,
      leadership   => 10,
      popular      => 10,
      loyalty      => 10,
      update_time  => time,
    });
  }

  sub get {
    my ($class, $id) = @_;
    $class->db->single(TABLE_NAME() => {id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
