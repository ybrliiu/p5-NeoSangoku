package Sangoku::Service::Player::Config {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Sangoku::Util qw/validate_values escape/;

  sub root {
    my ($class, $player_id) = @_;

    my $player = $class->model('Player')->get_joined_to_country_members($player_id);

    return {
      %{ $player->constants },
      PROFILE_LEN_MAX => $class->api('Player::Profile')->MESSAGE_LEN_MAX,
      ICONS_DIR_PATH  => $class->model('IconList')->ICONS_DIR_PATH,
      player          => $player,
      country         => $player->country,
      command_record  => $player->command_record,
      battle_record   => $player->battle_record,
    };
  }

  sub change_icon {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id icon/]);

    my $txn = $class->txn;
    my $player = $class->model('Player')->get($args->{player_id})->refetch({for_update => 1});

    my $validator = $class->validator($args);
    $player->validate_icon($validator);
    return $validator if $validator->has_error;

    $player->update({icon => $args->{icon}});
    $txn->commit;

    return $validator;
  }

  sub change_equipments_name {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id weapon_name guard_name book_name/]);

    my $txn = $class->txn;
    my $weapon = $class->model('Player::Weapon')->get($args->{player_id})->refetch({for_update => 1});
    my $guard  = $class->model('Player::Guard')->get($args->{player_id})->refetch({for_update => 1});
    my $book   = $class->model('Player::Book')->get($args->{player_id})->refetch({for_update => 1});

    my $validator = $class->validator($args);
    $_->validate_name($validator, $args) for ($weapon, $book, $guard);
    return $validator if $validator->has_error;

    $weapon->update({name => $args->{weapon_name}});
    $guard->update({name => $args->{guard_name}});
    $book->update({name => $args->{book_name}});
    $txn->commit;

    return $validator;
  }

  sub change_loyalty {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id loyalty/]);

    my $txn = $class->txn;
    my $player = $class->model('Player')->get($args->{player_id})->refetch({for_update => 1});

    my $validator = $class->validator($args);
    $player->validate_loyalty($validator);
    return $validator if $validator->has_error;

    $player->update({loyalty => $args->{loyalty}});
    $txn->commit;

    return $validator;
  }

  sub set_profile {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id profile/]);
    $args->{profile} = escape( $args->{profile} );

    my $model = $class->model('Player::Profile')->new(id => $args->{player_id});
    my $rec = $model->record->open('LOCK_EX');
    my $profile = $model->get;

    my $validator = $class->validator($args);
    $profile->validate_message($validator);

    if ($validator->has_error) {
      $rec->rollback;
    } else {
      $profile->message($args->{profile});
      $rec->close;
    }

    return $validator;
  }

  sub change_win_message {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id win_message/]);

    my $txn = $class->txn;
    my $player = $class->model('Player')->get($args->{player_id})->refetch({for_update => 1});

    my $validator = $class->validator($args);
    $player->validate_win_message($validator);
    return $validator if $validator->has_error;

    $player->update({win_message => $args->{win_message}});
    $txn->commit;

    return $validator;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
