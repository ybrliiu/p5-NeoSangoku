package Sangoku::Model::Country {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/load_child_module validate_values/;
  load_child_module(__PACKAGE__);

  use constant {
    TABLE_NAME   => 'country',
    NEUTRAL_DATA => {
      name  => '無所属',
      color => 'gray',
    },
  };

  sub init {
    my ($class) = @_;
    $class->create(NEUTRAL_DATA);
  }

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/name color/]);
    $class->db->do_insert(TABLE_NAME, $args);
  }

  # トランザクションが終わる前に king_id のプレイヤーを登録する必要がある
  sub regist {
    my ($class, $args) = @_;
    validate_values($args => [qw/name color king_id/]);

    $class->create({
      name  => $args->{name},
      color => $args->{color},
    });

    "${class}::Position"->create({
      name    => $args->{name},
      king_id => $args->{king_id},
    });
  }

  __PACKAGE__->meta->make_immutable();
}

1;
