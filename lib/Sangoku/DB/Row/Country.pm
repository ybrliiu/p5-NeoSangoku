package Sangoku::DB::Row::Country {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  use constant {
    NAME_LEN_MIN => 1,
    NAME_LEN_MAX => 16,
  };

  sub COLOR() { state $color = __PACKAGE__->config('color.conf')->{countrycolor} }

  __PACKAGE__->_generate_letter_method();

  sub position {
    my ($self, $positions_hash) = @_;
    return $self->{position} if exists $self->{position};
    $self->{position} = ref $positions_hash eq 'HASH'
      ? $positions_hash->{$self->name}
      : $self->model('Country::Position')->get($self->name);
  }

  sub players {
    my ($self, $players_hash) = @_;
    my $players = ref $players_hash eq 'HASH'
      ? [sort { $b->class <=> $a->class } grep { $_->country_name eq $self->name } values %$players_hash]
      : $self->model('Player')->search(country_name => $self->name);
    return $players;
  }

  sub towns {
    my ($self, $towns) = @_;
    my $country_towns = ref $towns eq 'ARRAY'
      ? [grep { $_->country_name eq $self->name } @$towns]
      : $self->model('Town')->search(country_name => $self->name);
    return $country_towns;
  }

  sub validate_regist_data {
    my ($class, $validator, $args, $town) = @_;

    $validator->set_message('country_name.length' => "[_1]は" . NAME_LEN_MIN . "文字以上" . NAME_LEN_MAX . "文字以下で入力してください。");
    $validator->set_message('country_color.not_null' => '[_1]を選択してください。');

    $validator->check(
      country_name  => ['NOT_NULL', [LENGTH => (NAME_LEN_MIN, NAME_LEN_MAX)]],
      country_color => ['NOT_NULL', [CHOICE => (keys %{ COLOR() })]],
    );
  }

  __PACKAGE__->meta->make_immutable();
}

1;
