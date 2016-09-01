package Sangoku::Model::Player {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Parent';

  use Sangoku::Util qw/load_child_module validate_values load_config/;
  load_child_module(__PACKAGE__);

  use constant TABLE_NAME => 'player';

  sub ADMINISTARTOR_DATA() {
    my $site = load_config('etc/config/site.conf')->{'site'};
    state $data = {
      player => {
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
      },
      weapon => {
        player_id => $site->{admin_id},
        power     => 0,
      },
      guard  => {
        player_id => $site->{admin_id},
        power     => 0,
      },
      book   => {
        player_id => $site->{admin_id},
        power     => 0,
      },
    };
  }

  after 'init' => sub {
    my ($class) = @_;

    # 管理人を登録
    $class->regist(ADMINISTARTOR_DATA);
  };

  sub get {
    my ($class, $id) = @_;
    return $class->db->single(TABLE_NAME, {id => $id});
  }

  sub delete {
    my ($class, $id) = @_;
    $class->db->delete(TABLE_NAME, {id => $id});
  }

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/id name pass icon country_name town_name force intellect leadership popular loyalty update_time/]);
    $class->db->do_insert(TABLE_NAME, $args);
  }

  sub regist {
    my ($class, $args) = @_;
    validate_values($args => [qw/player weapon guard book/]);

    $class->create($args->{player});

    for (qw/Command CommandList CommandLog/) {
      my $model = "$class::$_"->new(id => $args->{player}{id});
      $model->init();
    }

    for (qw/weapon guard book/) {
      my $pkg = ucfirst $_;
      "$class::$pkg"->create($args->{$_});
    }

    "$class::$_"->create($args->{player}{id}) for qw/BattleRecord Config Soldier/;
  }

  sub erase {
    my ($class, $id) = @_;

    $class->delete($id);
    for (qw/Command CommandList CommandLog/) {
      my $model = "$class::$_"->new(id => $id);
      $model->remove();
    }
  }

  __PACKAGE__->meta->make_immutable();
}

1;

__END__
