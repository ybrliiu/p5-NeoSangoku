package Sangoku::DB::Row::Player {

  use Sangoku;
  use parent 'Teng::Row';

  use Sangoku::Util qw/load_config/;
  use Sangoku::Model::IconList;

  use constant {
    CONSTANTS => {
      NAME_LEN_MIN    => 1,
      NAME_LEN_MAX    => 15,
      ID_LEN_MIN      => 6,
      ID_LEN_MAX      => 16,
      PASS_LEN_MIN    => 6,
      PASS_LEN_MAX    => 16,
      LOYALTY_MIN     => 0,
      LOYALTY_MAX     => 100,
      PROFILE_LEN_MAX => 1000,
      MAIL_LEN_MAX    => 40,
    },
    ABILITY_LIST      => [qw/force intellect leadership popular/],
    EQUIPMENT_LIST    => [qw/weapon guard book/],
    LANK_UP           => 500,   # 階級アップに必要な階級値
		DELETE_TURN       => 72,    # 放置削除にかかるターン数
		PLAYER_UPDATETIME => 3600,  # 更新時間(分)
  };

  sub icon_path {
    my ($self) = @_;
    return Sangoku::Model::IconList->ICONS_DIR_PATH . $self->icon . '.gif';
  }

  {

    my $lank = load_config('etc/config/data/lank.conf')->{lank};
    my $LANK_MAX = @$lank;

    sub lank {
      my ($self) = @_;
      return ($self->class / LANK_UP) > $LANK_MAX ? $LANK_MAX : int($self->class / LANK_UP);
    }

    sub lank_name {
      my ($self) = @_;
      return $lank->[$self->lank];
    }

  }

  sub delete_until {
    my ($self) = @_;
    return DELETE_TURN - $self->delete_turn;
  }

  sub check_pass {
    my ($self, $pass) = @_;
    return $self->pass eq $pass;
  }

  __PACKAGE__->_generate_methods();

  sub _generate_methods {
    no strict 'refs';
    for my $method_name (@{ EQUIPMENT_LIST() }) {
      my $class_name = ucfirst $method_name;
      *{$method_name} = sub {
        use strict 'refs';
        my ($self, $hash) = @_;
        return defined $hash
          ? $hash->{$self->id}
          : "Sangoku::Model::Player::$class_name"->get($self->id);
      };
    }
  }

}

1;
