package Sangoku::DB::Row::Unit {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  use constant {
    NAME_LEN_MIN    => 1,
    NAME_LEN_MAX    => 15,
    MESSAGE_LEN_MAX => 300,
  };

  sub is_same_country {
    my ($self, $player) = @_;
    return $self->country_name eq $player->country_name;
  }

  sub is_leader {
    my ($self, $player) = @_;
    return $self->leader_id eq $player->id;
  }

  sub players {
    my ($self, $players_hash) = @_;
    return $self->{players} if exists $self->{players};
    $self->{players} = ref $players_hash eq 'HASH'
      ? [grep { $_->unit_id eq $self->id } values %$players_hash]
      : $self->model('Unit::Members')->search(unit_id => $self->id);
  }

  sub players_without_leader {
    my ($self, $players_hash) = @_;
    if (ref $players_hash eq 'HASH') {
      return [grep { $_->id ne $self->leader_id } @{ $self->players($players_hash) }];
    } else {
      # call SQL
    }
  }

  sub leader {
    my ($self, $players_hash) = @_;
    return $self->{leader} if exists $self->{leader};
    $self->{leader} = ref $players_hash eq 'HASH'
      ? $players_hash->{$self->leader_id}
      : $self->model('Player')->get($self->leader_id);
  }

  sub letter_model {
    my ($self) = @_;
    return $self->model('Unit::Letter')->new(
      id   => $self->id,
      name => $self->name,
    );
  }

  sub switch_join_permit {
    my ($self) = @_;
    $self->update({join_permit => $self->join_permit ? 0 : 1});
  }

  sub validate_name_and_message {
    my ($class, $validator) = @_;
    $validator->check(
      name    => ['NOT_NULL', [LENGTH => (NAME_LEN_MIN, NAME_LEN_MAX)]],
      message => [[LENGTH => (0, MESSAGE_LEN_MAX)]],
    );
  }

  __PACKAGE__->meta->make_immutable();
}

1;
