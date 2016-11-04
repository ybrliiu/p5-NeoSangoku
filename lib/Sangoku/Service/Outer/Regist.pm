package Sangoku::Service::Outer::Regist {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use List::Util qw/sum/;
  use Sangoku::Util qw/validate_values/;

  sub root {
    my ($class) = @_;

    my $towns = $class->model('Town')->get_all();
    my $site = $class->model('Site')->get();
    my $passed_year = $site->passed_year();

    return {
      %{ $class->row('Player')->constants },
      ability_max          => $class->row('Player')->ability_max($passed_year),
      ability_sum          => $class->row('Player')->ability_sum($passed_year),
      PROFILE_LEN_MAX      => $class->api('Player::Profile')->MESSAGE_LEN_MAX,
      COUNTRY_COLOR        => $class->row('Country')->COLOR,
      COUNTRY_NAME_LEN_MIN => $class->row('Country')->NAME_LEN_MIN,
      COUNTRY_NAME_LEN_MAX => $class->row('Country')->NAME_LEN_MAX,
      ICONS_DIR_PATH       => $class->model('IconList')->ICONS_DIR_PATH,
      current_player       => $class->model('Player')->count_all,
      towns                => $towns,
    };
  }

  sub complete_regist {
    my ($class, $id) = @_;
    return {player => $class->model('Player')->get($id)};
  }

  sub regist {
    my ($class, $args) = @_;
    validate_values($args => [qw/name icon town id pass
      force intellect leadership popular loyalty profile confirm_rule/]);

    my $validator = $class->validator($args);
    my $txn = $class->txn;

    $class->row('Player')->validate_regist_data($validator, $args);

    my $town = $class->model('Town')->get($args->{town})->refetch({for_update => 1});

    my @is_input_country_form = grep { $args->{"country_$_"} } qw/name color/;
    if ($town->can_establish_nation || @is_input_country_form) {

      $class->row('Country')->validate_regist_data($validator, $args);

      # 下3つのメソッド呼び出しを以下のようにしてもいいかも
      # $class->model('Country')->regist_country({
      #   params => $args,
      #   validator => $validator,
      #   town => $town,
      #   regist_player => sub { $class->_regist_player(...) },
      # });

      $class->_create_country($args, $validator, $town);
      $class->_regist_player($args, $validator, $town);
      $class->_create_country_position($args, $validator);

      unless ($validator->has_error) {
        my $log = qq{<span class="darkblue">【建国】</span>新しく$args->{name}が$args->{town}に$args->{country_name}を建国しました！};
        $class->model($_)->add($log) for qw/MapLog HistoryLog/;
      }

    } else {

      $class->_regist_player($args, $validator, $town);

      $class->model('MapLog')->add(qq{<span class="lightblue">［仕官］</span>新しく$args->{name}が@{[ $town->country_name ]}に仕官しました。})
        unless $validator->has_error;

    }

    $validator->has_error ? $txn->rollback : $txn->commit;
    return $validator;
  }

  sub _create_country {
    my ($class, $param, $validator, $town) = @_;

    $validator->set_error_and_message(town => (cant_establish => 'その都市は既に他の国が支配しています。'))
      unless $town->can_establish_nation;

    my $country = $class->model('Country')->get($param->{country_name});
    $validator->set_error(country_name => 'already_exist') if defined $country;

    return if $validator->has_error();

    $class->model('Country')->create({
      name  => $param->{country_name},
      color => $param->{country_color},
    });
    $town->update({country_name => $param->{country_name}});
  }

  sub _create_country_position {
    my ($class, $param, $validator) = @_;

    return if $validator->has_error;

    $class->model('Country::Position')->create({
      name    => $param->{country_name},
      king_id => $param->{id},
    });
  }

  sub _regist_player {
    my ($class, $param, $validator, $town) = @_;
    $town->refetch();
   
    my $player = $class->model('Player')->get($param->{id});
    $validator->set_error_and_message(id => 'already_exist') if defined $player;
    
    my $rows = $class->model('Player')->search(name => $param->{name});
    $validator->set_error(name => 'already_exist') if @$rows;

    return if $validator->has_error();

    my $equipments_status = {
      player_id => $param->{id},
      power     => 0,
    };

    my $player_info = {
      player => {
        id   => $param->{id},
        name => $param->{name},
        pass => $param->{pass},
        icon => $param->{icon},
        country_name => $town->country_name,
        town_name    => $town->name,
        force        => $param->{force},
        intellect    => $param->{intellect},
        leadership   => $param->{leadership},
        popular      => $param->{popular},
        loyalty      => $param->{loyalty},
        update_time  => time,
      },
      profile => $param->{profile},
      weapon  => $equipments_status,
      guard   => $equipments_status,
      book    => $equipments_status,
    };

    $class->model('Player')->regist($player_info);
  }

}

1;
