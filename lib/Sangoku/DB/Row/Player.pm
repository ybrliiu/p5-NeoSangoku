package Sangoku::DB::Row::Player {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  use Carp qw/croak/;
  use Sangoku::Util qw/load_config/;

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

  __PACKAGE__->_generate_methods();

  sub _generate_methods {
    no strict 'refs';
    for my $method_name (@{ EQUIPMENT_LIST() }, 'soldier') {
      my $class_name = ucfirst $method_name;
      *{$method_name} = sub {
        use strict 'refs';
        my ($self, $hash) = @_;
        return defined $hash
          ? $hash->{$self->id}
          : $self->model("Player::$class_name")->get($self->id);
      };
    }
  }

  sub command_log {
    my ($self) = @_;
    return $self->model('Player::CommandLog')->new(id => $self->id);
  }

  sub country {
    my ($self, $countreis_hash) = @_;
    return defined($countreis_hash)
      ? $countreis_hash->{$self->country_name}
      : $self->model('Country')->get($self->country_name);
  }

  sub check_pass {
    my ($self, $pass) = @_;
    return $self->pass eq $pass;
  }

  sub delete_until {
    my ($self) = @_;
    return DELETE_TURN - $self->delete_turn;
  }

  sub icon_path {
    my ($self) = @_;
    return $self->model('IconList')->ICONS_DIR_PATH . $self->icon . '.gif';
  }

  sub invite {
    my ($self) = @_;
    return $self->model('Player::Invite')->new(id => $self->id);
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

  sub letter {
    my ($self) = @_;
    return $self->model('Player::Letter')->new(id => $self->id);
  }

  sub town {
    my ($self, $towns_hash) = @_;
    return defined($towns_hash)
      ? $towns_hash->{$self->town_name}
      : $self->model('Town')->get($self->town_name);
  }

  sub is_delong_unit {
    my ($self) = @_;
    return $self->unit_id ? 1 : 0;
  }

  sub unit {
    my ($self, $units_hash) = @_;
    return defined($units_hash)
      ? $units_hash->{$self->unit_id}
      : $self->model('Unit')->get($self->unit_id);
  }

  sub unit_name {
    my ($self, $units_hash) = @_;
    return $self->is_delong_unit ? $self->unit($units_hash)->name : '無所属';
  }

}

1;
