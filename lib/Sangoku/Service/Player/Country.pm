package Sangoku::Service::Player::Country {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use Sangoku::Util qw/validate_values escape/;

  use constant NUMBER_OF_THREADS_PER_PAGE => 5;

  sub root {
    my ($class, $player_id) = @_;
    my $player       = $class->model('Player')->get_joined_to_country_members($player_id);
    my $players      = $class->model('Player')->search_joined_to_country_members(country_name => $player->country_name);
    my $players_hash = $class->model('Player')->to_hash($players);
    my $country      = $player->country;
    my $towns        = $class->model('Town')->search(country_name => $player->country_name);
    return {
      player       => $player,
      players      => $players,
      players_hash => $players_hash,
      country      => $country,
      towns        => $towns,
    };
  }

  sub member {
    my ($class, $player_id) = @_;
    my $player  = $class->model('Player')->get_joined_to_country_members($player_id);
    my $country = $player->country;
    my $players = $country->players;
    return {
      player  => $player,
      players => $players,
      country => $country,
      ( map {
        my $model_name = 'Player::' . ucfirst $_;
        my $list = $class->model( $model_name )->search_joined_to_country_members(country_name => $player->country_name);
        $_ . 's_hash' => $class->model($model_name)->to_hash($list);
      } @{ $player->EQUIPMENT_LIST }, 'soldier' ),
    };
  }

  sub conference {
    my ($class, $player_id, $page) = @_;
    $page //= 0;

    my $player  = $class->model('Player')->get_joined_to_country_members($player_id);
    my $country = $player->country;
    my $threads = $class->model('Country::ConferenceThread')->new(name => $country->name)->get_by_page($page, NUMBER_OF_THREADS_PER_PAGE); 
    my $thread  = $class->row('Country::ConferenceThread');

    return {
      player                 => $player,
      country                => $country,
      threads                => $threads,
      THREAD_TITLE_LEN_MIN   => $thread->TITLE_LEN_MIN,
      THREAD_TITLE_LEN_MAX   => $thread->TITLE_LEN_MAX,
      THREAD_MESSAGE_LEN_MAX => $thread->MESSAGE_LEN_MAX,
      REPLY_MESSAGE_LEN_MAX  => $class->row('Country::ConferenceReply')->MESSAGE_LEN_MAX,
    };
  }

  sub create_conference_thread {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id title message/]);
    $args->{message} = escape( $args->{message} );

    my $txn = $class->txn;
    my $validator = $class->validator($args);

    $class->row('Country::ConferenceThread')->validate_new_thread($validator);
    if ( $validator->has_error ) {
      $txn->rollback;
      return $validator;
    }

    my $player = $class->model('Player')->get_joined_to_country_members( $args->{player_id} );
    $class->model('Country::ConferenceThread')->new(name => $player->country_name)->add({
      sender  => $player,
      title   => $args->{title},
      message => $args->{message},
    });

    $txn->commit;
    return $validator;
  }

  sub write_conference_reply {
    my ($class, $args) = @_;
    validate_values($args => [qw/player_id thread_id reply/]);
    $args->{reply} = escape( $args->{reply} );

    my $txn = $class->txn;
    my $validator = $class->validator($args);

    $class->row('Country::ConferenceReply')->validate_message($validator);
    if ( $validator->has_error ) {
      $txn->rollback;
      return $validator;
    }

    my $player = $class->model('Player')->get_joined_to_country_members( $args->{player_id} );
    my $model  = $class->model('Country::ConferenceReply')->new({
      name      => $player->country_name,
      thread_id => $args->{thread_id},
    });
    $model->add({
      sender  => $player,
      message => $args->{reply},
    });

    $txn->commit;
    return $validator;
  }
  
}

1;
