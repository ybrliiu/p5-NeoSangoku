package Sangoku::DB::Row::Player {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  use Carp qw/croak/;
  use List::Util qw/sum/;
  use Sangoku::Util qw/minute_second/;

  use constant {
    NAME_LEN_MIN    => 1,
    NAME_LEN_MAX    => 15,
    ID_LEN_MIN      => 6,
    ID_LEN_MAX      => 16,
    PASS_LEN_MIN    => 6,
    PASS_LEN_MAX    => 16,
    LOYALTY_MIN     => 0,
    LOYALTY_MAX     => 100,
    MAIL_LEN_MAX    => 40,

    ABILITY_LIST     => [qw/force intellect leadership popular/],
    ABILITY_MIN      => 1,
    ABILITY_MAX_BASE => 100,
    ABILITY_SUM_BASE => 160,
    ABILITY_COEF     => 0.9,

    EQUIPMENT_LIST         => [qw/weapon guard book/],
    EQUIPMENT_NAME_LEN_MAX => 15,
    WIN_MESSAGE_LEN_MAX    => 30,

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

  sub country_name {
    my ($self) = @_;
    # row を get_joined で取得した場合
    return $self->{row_data}{country_name} if exists $self->{row_data}{country_name};
    return $self->{country_name} if exists $self->{country_name};
    my $member = $self->model('Country::Members')->get_by_player_id($self->id);
    $self->{country_name} = defined $member ? $member->country_name : undef;
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

  sub invite_model {
    my ($self) = @_;
    return $self->model('Player::Invite')->new(id => $self->id);
  }

  {
    my $lank = __PACKAGE__->config('data/lank.conf')->{lank};
    my $MAX_LANK = @$lank;

    sub lank {
      my ($self) = @_;
      return ($self->class / LANK_UP) > $MAX_LANK ? $MAX_LANK : int($self->class / LANK_UP);
    }

    sub lank_name {
      my ($self) = @_;
      return $lank->[$self->lank];
    }
  }

  #  $model->get_without_same_letter($self, $limit);
  sub letter_model {
    my ($self) = @_;
    return $self->model('Player::Letter')->new(id => $self->id);
  }

  sub profile {
    my ($self) = @_;
    my $model = $self->model('Player::Profile')->new(id => $self->id);
    return $model->get->message;
  }

  sub read_letter {
    my ($self) = @_;
    my $model = $self->model('Player::ReadLetter')->new(id => $self->id);
    return $model->get;
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
    # row を get_joined で取得した場合
    return $self->{row_data}{unit_id} if exists $self->{row_data}{unit_id};
    return $self->{unit_id} if exists $self->{unit_id};
    my $member = $self->model('Unit::Members')->get_by_player_id($self->id);
    $self->{unit_id} = defined $member ? $member->unit_id : undef;
  }

  sub unit_name {
    my ($self, $units_hash) = @_;
    return $self->is_belong_unit ? $self->unit($units_hash)->name : '無所属';
  }

  sub unit_letter_model {
    my ($self) = @_;
    return $self->is_belong_unit ? $self->unit->letter_model : undef;
  }

  sub unit_letter {
    my ($self, $model, $limit) = @_;
    return $self->is_belong_unit ? $model->get($limit) : [];
  }

  sub validate_icon {
    my ($class, $validator) = @_;
    $validator->check(icon => ['NOT_NULL', [BETWEEN => (0, $class->model('IconList')->MAX)]]);
  }

  sub validate_loyalty {
    my ($class, $validator) = @_;
    $validator->check(loyalty => ['NOT_NULL', [BETWEEN => (LOYALTY_MIN, LOYALTY_MAX)]]);
  }

  sub validate_win_message {
    my ($class, $validator) = @_;
    $validator->set_message('win_message.length' => "[_1]は" . WIN_MESSAGE_LEN_MAX . "文字以内で入力してください");
    $validator->check(win_message => [[LENGTH => (0, WIN_MESSAGE_LEN_MAX)]]);
  }

  sub validate_regist_data {
    my ($class, $validator, $args) = @_;

    my $site = $class->model('Site')->get();
    my $passed_year = $site->passed_year();

    $validator->set_message('id.length'          => "[_1]は" . ID_LEN_MIN . "文字以上" . ID_LEN_MAX . "文字以下で入力してください。");
    $validator->set_message('id.regex'           => "[_1]で使用可能な文字は半角英数字及び'_'だけです。");
    $validator->set_message('pass.length'        => "[_1]は" . PASS_LEN_MIN . "文字以上" . PASS_LEN_MAX . "文字以下で入力してください。");
    $validator->set_message('confirm_rule.equal' => '規約に同意できない場合は登録できません。');

    $validator->check(
      name => ['NOT_NULL', [LENGTH => (NAME_LEN_MIN, NAME_LEN_MAX)]],
      town => ['NOT_NULL'],
      id   => ['NOT_NULL', [REGEX => qr/^[a-zA-Z0-9_]+$/], [LENGTH => (ID_LEN_MIN, ID_LEN_MAX)]],
      pass => ['NOT_NULL', 'ASCII', [LENGTH => (PASS_LEN_MIN, PASS_LEN_MAX)]],
      ( map { $_ => ['NOT_NULL', [BETWEEN => (ABILITY_MIN, $class->ability_max($passed_year))]] } @{ ABILITY_LIST() }),
      mail         => ['ASCII', [LENGTH => (0, MAIL_LEN_MAX)]],
      confirm_rule => ['NOT_NULL', [EQUAL => 1]],
    );
    $class->validate_icon($validator);
    $class->validate_loyalty($validator);
    $class->api('Player::Profile')->validate_message($validator);

    $validator->set_error_and_message(pass => (same => 'IDとパスワードは同じにできません！'))
      if $args->{pass} eq $args->{id};

    my $ability_sum = $class->ability_sum($passed_year);
    $args->{ability_sum} = sum map { $args->{$_} || 0 } @{ ABILITY_LIST() };
    $validator->set_error_and_message('ability' => (sum => "能力の合計値は${ability_sum}になるようにしてください！"))
      unless $args->{ability_sum} == $ability_sum;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
