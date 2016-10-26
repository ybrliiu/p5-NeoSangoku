package Sangoku::Model::Unit {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values/;
  use Sangoku::Model::Unit::Members;

  use constant TABLE_NAME => 'unit';

  around 'get' => sub {
    my ($orig, $class, @args) = @_;

    if (@args == 1) {
      my ($id) = @args;
      $class->$orig($id);
    } else {
      my ($unit_name, $country_name) = @args;
      return $class->db->single(TABLE_NAME, {
        name         => $unit_name,
        country_name => $country_name,
      });
    }

  };

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/leader name message/]);

    $class->db->do_insert(TABLE_NAME, {
      leader_id    => $args->{leader}->id,
      country_name => $args->{leader}->country_name,
      name         => $args->{name},
      message      => $args->{message},
    });
  }

  sub regist {
    my ($class, $args) = @_;
    validate_values($args => [qw/leader name message/]);

    $class->create($args);

    # leader の情報をメンバー一覧に追加
    my $leader = $args->{leader};
    my $unit = $class->get($args->{name}, $leader->country_name);
    my $member = Sangoku::Model::Unit::Members->new(id => $unit->id);
    $member->add($leader);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
