package Sangoku::Model::Player {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/load_child_module validate_keys load_config/;
  load_child_module(__PACKAGE__);

  use constant TABLE_NAME => 'player';

  after 'init' => sub {
    my ($class) = @_;

    # 管理人を登録
    $class->regist(%{ $class->administer_data() });
  };

  sub administer_data {
    my ($class) = @_;

    my $site = load_config('etc/config/site.conf')->{'site'};
    return {
      id   => $site->{admin_id},
      name => '管理人',
      pass => $site->{admin_pass},
      icon => 0,
      country_name => '無所属',
      town_name    => '開封',
      force        => 10,
      intellect    => 10,
      leadership   => 10,
      popular      => 10,
      loyalty      => 10,
      update_time  => time,
    };
  }

  sub get {
    my ($class, $id) = @_;
    return $class->db->single(TABLE_NAME() => {id => $id});
  }

  sub regist {
    my ($class, %args) = @_;
    validate_keys(\%args => [qw/id name pass icon country_name town_name force intellect leadership popular loyalty update_time/]);

    $class->regist_body(%args);

    "Sangoku::Model::Player::$_"->new(id => $args{id})->init() for qw/Command CommandList CommandLog/;
    "Sangoku::Model::Player::$_"->regist(player_id => $args{id}, power => 0) for qw/Weapon Guard Book/;
  }

  sub regist_body {
    my ($class, %args) = @_;
    $class->db->do_insert(TABLE_NAME() => \%args);
  }

  sub delete {
    my ($class, $id) = @_;
    $class->db->delete_body($id);
    "Sangoku::Model::Player::$_"->new($id)->remove() for qw/Command CommandList CommandLog/;
  }

  sub delete_body {
    my ($class, $id) = @_;
    $class->db->delete(TABLE_NAME() => {id => $id});
  }

  __PACKAGE__->meta->make_immutable();
}

1;
