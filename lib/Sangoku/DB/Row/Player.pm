package Sangoku::DB::Row::Player {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  use Carp qw/croak/;
  use Sangoku::Util qw/config minute_second get_all_constants/;

  use constant {
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

    ABILITY_LIST     => [qw/force intellect leadership popular/],
    ABILITY_MIN      => 1,
    ABILITY_MAX_BASE => 100,
    ABILITY_SUM_BASE => 160,
    ABILITY_COEF     => 0.9,

    EQUIPMENT_LIST    => [qw/weapon guard book/],
    LANK_UP           => 500,   # 階級アップに必要な階級値
		DELETE_TURN       => 72,    # 放置削除にかかるターン数
		PLAYER_UPDATETIME => 3600,  # 更新時間(分)
  };

  __PACKAGE__->_generate_relation_methods();

  sub _generate_relation_methods {
    no strict 'refs';
    for my $method_name (@{ EQUIPMENT_LIST() }, qw/soldier battle_record/) {
      my $class_name = join '', map { ucfirst $_ } split /_/, $method_name;
      *{$method_name} = sub {
        use strict 'refs';
        my ($self, $hash) = @_;
        return $self->{$method_name} if exists $self->{$method_name};
        $self->{$method_name} = ref $hash eq 'HASH'
          ? $hash->{$self->id}
          : $self->model("Player::$class_name")->get($self->id);
      };
    }
  }

  sub ability_max {
    my ($class, $passed_year) = @_;
    return ABILITY_MAX_BASE + int($passed_year * ABILITY_COEF);
  }

  sub ability_sum {
    my ($class, $passed_year) = @_;
    return ABILITY_SUM_BASE + int($passed_year * ABILITY_COEF);
  }

  sub command {
    my ($self, $limit) = @_;
    my $model = $self->model('Player::Command')->new(id => $self->id);
    return $model->get($limit);
  }

  sub command_log {
    my ($self, $limit) = @_;
    my $model = $self->model('Player::CommandLog')->new(id => $self->id);
    return $model->get($limit);
  }

  sub command_record {
    my ($self) = @_;
    return $self->{command_record}  if exists $self->{command_record};
    $self->{command_record} = $self->model('Player::CommandRecord')->new(id => $self->id)->get;
  }

  sub country {
    my ($self, $countreis_hash) = @_;
    return $self->{country} if exists $self->{country};
    $self->{country} = ref $countreis_hash eq 'HASH'
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

  sub format_update_time {
    my ($self) = @_;
    return minute_second($self->update_time);
  }

  sub icon_path {
    my ($self) = @_;
    return $self->model('IconList')->ICONS_DIR_PATH . $self->icon . '.gif';
  }

  sub is_belong_unit {
    my ($self) = @_;
    return $self->unit_id ? 1 : 0;
  }

  sub is_same_unit {
    my ($self, $player) = @_;
    return $self->unit_id eq $player->unit_id;
  }

  sub invite {
    my ($self, $limit) = @_;
    my $model = $self->model('Player::Invite')->new(id => $self->id);
    return $model->get($limit);
  }

  {
    config('data/lank.conf');
    my $lank = config->{lank};
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
    my ($self, $limit) = @_;
    my $model = $self->model('Player::Letter')->new(id => $self->id);
    return $model->get_without_same_letter($self, $limit);
  }

  sub profile {
    my ($self) = @_;
    my $model = $self->model('Player::Profile')->new(id => $self->id);
    return $model->get->message;
  }

  sub town {
    my ($self, $towns_hash) = @_;
    return $self->{town} if exists $self->{town};
    $self->{town} = ref $towns_hash eq 'HASH'
      ? $towns_hash->{$self->town_name}
      : $self->model('Town')->get($self->town_name);
  }

  sub unit {
    my ($self, $units_hash) = @_;
    return $self->{unit} if exists $self->{unit};
    $self->{unit} = ref $units_hash eq 'HASH'
      ? $units_hash->{$self->unit_id}
      : $self->model('Unit')->get($self->unit_id);
  }

  sub unit_id {
    my ($self) = @_;
    return $self->{unit_id} if exists $self->{unit_id};
    my $member = $self->model('Unit::Members')->get_by_player_id($self->id);
    $self->{unit_id} = defined $member ? $member->unit_id : undef;
  }

  sub unit_name {
    my ($self, $units_hash) = @_;
    return $self->is_belong_unit ? $self->unit($units_hash)->name : '無所属';
  }

  sub unit_letter {
    my ($self, $limit) = @_;
    return $self->is_belong_unit ? $self->unit->letter($limit) : [];
  }

  __PACKAGE__->meta->make_immutable();
}

1;
