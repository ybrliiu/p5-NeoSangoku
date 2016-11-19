package Sangoku::Model::Player {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Model::Unit::Members;
  use Sangoku::Util qw/load_child_module validate_values load_config/;
  load_child_module(__PACKAGE__);

  use constant {
    TABLE_NAME           => 'player',
    CHILD_RECORD_MODULES => [qw/Command CommandList CommandLog Profile ReadLetter/],
  };

  sub ADMINISTARTOR_DATA() {
    my $site = load_config('site.conf')->{'site'};
    my $equipments_status = {
      player_id => $site->{admin_id},
      power     => 0,
    };
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
      profile => '',
      weapon  => $equipments_status,
      guard   => $equipments_status,
      book    => $equipments_status,
    };
  }

  sub init {
    my ($class) = @_;
    # 管理人を登録
    $class->regist(ADMINISTARTOR_DATA);
  }

  sub create {
    my ($class, $args) = @_;
    validate_values($args => [qw/id name pass icon country_name town_name
      force intellect leadership popular loyalty update_time/]);
    $class->db->do_insert(TABLE_NAME, $args);
  }

  sub get_by_name {
    my ($class, $name) = @_;
    return $class->db->single(TABLE_NAME, {name => $name});
  }

  sub get_joined {
    my ($class, $id) = @_;
    my @rows = $class->db->search_by_sql(
      "SELECT * FROM @{[ TABLE_NAME ]}
        LEFT JOIN @{[ Sangoku::Model::Unit::Members->TABLE_NAME ]}
        ON id = player.id
        WHERE id = ?",
      [$id],
      TABLE_NAME, 
    );
    return $rows[0];
  }

  sub regist {
    my ($class, $args) = @_;
    validate_values($args => [qw/player profile weapon guard book/]);

    $class->create($args->{player});

    for (@{ CHILD_RECORD_MODULES() }) {
      my $model = "$class::$_"->new(id => $args->{player}{id});
      $_ eq 'Profile' ? $model->init($args->{profile}) : $model->init;
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

    for (@{ CHILD_RECORD_MODULES() }) {
      my $model = "$class::$_"->new(id => $id);
      $model->remove();
    }
  }

  sub erase_all {
    my ($class) = @_;
    $class->delete_all();
    "$class::$_"->remove_all() for @{ CHILD_RECORD_MODULES() };
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;

__END__
