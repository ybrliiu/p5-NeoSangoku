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
      %{ Sangoku::DB::Row::Player->get_all_constants },
      ability_max          => Sangoku::DB::Row::Player->ability_max($passed_year),
      ability_sum          => Sangoku::DB::Row::Player->ability_sum($passed_year),
      COUNTRY_COLOR        => Sangoku::DB::Row::Country->COLOR,
      COUNTRY_NAME_LEN_MIN => Sangoku::DB::Row::Country->NAME_LEN_MIN,
      COUNTRY_NAME_LEN_MAX => Sangoku::DB::Row::Country->NAME_LEN_MAX,
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
      force intellect leadership popular loyalty confirm_rule/]);

    my $validator = $class->validator($args);
    my $txn = $class->txn;

    # validate player info
    {
      # number_for_validation -> nfv
      state $nfv = Sangoku::DB::Row::Player->get_all_constants();
      my %nfv = %$nfv;
      my $site = $class->model('Site')->get();
      my $passed_year = $site->passed_year();
      $nfv{ability_max} = Sangoku::DB::Row::Player->ability_max($passed_year);
      $nfv{ability_sum} = Sangoku::DB::Row::Player->ability_sum($passed_year);

      $validator->set_message('id.length' => "[_1]は$nfv{ID_LEN_MIN}文字以上$nfv{ID_LEN_MAX}文字以下で入力してください。");
      $validator->set_message('id.regex' => "[_1]で使用可能な文字は半角英数字及び'_'だけです。");
      $validator->set_message('pass.length' => "[_1]は$nfv{PASS_LEN_MIN}文字以上$nfv{PASS_LEN_MAX}文字以下で入力してください。");
      $validator->set_message('confirm_rule.equal' => '規約に同意できない場合は登録できません。');

      $validator->check(
        name => ['NOT_NULL', [LENGTH => ($nfv{NAME_LEN_MIN}, $nfv{NAME_LEN_MAX})]],
        icon => ['NOT_NULL', [BETWEEN => (0, $class->model('IconList')->MAX)]],
        town => ['NOT_NULL'],
        id   => ['NOT_NULL', [REGEX => qr/^[a-zA-Z0-9_]+$/], [LENGTH => ($nfv{ID_LEN_MIN}, $nfv{ID_LEN_MAX})]],
        pass => ['NOT_NULL', 'ASCII', [LENGTH => ($nfv{PASS_LEN_MIN}, $nfv{PASS_LEN_MAX})]],
        (map {
          $_ => ['NOT_NULL', [BETWEEN => ($nfv{ABILITY_MIN}, $nfv{ability_max})]]
        } @{ $nfv{ABILITY_LIST} }),
        loyalty => ['NOT_NULL', [LENGTH => ($nfv{LOYALTY_MIN}, $nfv{LOYALTY_MAX})]],
        profile => [[LENGTH => (0, $nfv{PROFILE_LEN_MAX})]],
        mail    => ['ASCII', [LENGTH => (0, $nfv{MAIL_LEN_MAX})]],
        confirm_rule => ['NOT_NULL', [EQUAL => 1]],
      );

      $validator->set_error_and_message(pass => (same => 'IDとパスワードは同じにできません！'))
        if $args->{pass} eq $args->{id};

      my $ability_sum = sum map { $args->{$_} || 0 } @{ $nfv{ABILITY_LIST} };
      $validator->set_error_and_message('ability' => (sum => "能力の合計値は$nfv{ability_sum}になるようにしてください！"))
        unless $ability_sum == $nfv{ability_sum};

    }

    my $town = $class->model('Town')->get($args->{town})->refetch({for_update => 1});

    my @is_input_country_form = grep { $args->{"country_$_"} } qw/name color/;
    if ($town->can_establish_nation || @is_input_country_form) {

      # validate country info
      {
        # number_for_validation -> nfv
        state $nfv = Sangoku::DB::Row::Country->get_all_constants();
        my %nfv = %$nfv;

        $validator->set_message('country_name.length' => "[_1]は$nfv{NAME_LEN_MIN}文字以上$nfv{NAME_LEN_MAX}文字以下で入力してください。");
        $validator->set_message('country_color.not_null' => '[_1]を選択してください。');

        $validator->check(
          country_name  => ['NOT_NULL', [LENGTH => ($nfv{NAME_LEN_MIN}, $nfv{NAME_LEN_MAX})]],
          country_color => ['NOT_NULL', [CHOICE => (keys %{ $nfv{COLOR} })]],
        );

        $validator->set_error_and_message(town => (cant_establish => 'その都市は既に他の国が支配しています。'))
          unless $town->can_establish_nation;
      }

      # 下3つのメソッド呼び出しを以下のようにしてもいいかも
      # $class->_regist_country({
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

      unless ($validator->has_error) {
        $class->model('MapLog')->add(qq{<span class="lightblue">［仕官］</span>新しく$args->{name}が@{[ $town->country_name ]}に仕官しました。})
      }

    }

    $validator->has_error ? $txn->rollback : $txn->commit;
    return $validator;
  }

  sub _create_country {
    my ($class, $param, $validator, $town) = @_;

    my $country = $class->model('Country')->get($param->{country_name});
    $validator->set_error(country_name => 'already_exist') if defined $country;

    return () if $validator->has_error();

    $class->model('Country')->create({
      name  => $param->{country_name},
      color => $param->{country_color},
    });
    $town->update({country_name => $param->{country_name}});
  }

  sub _create_country_position {
    my ($class, $param, $validator) = @_;

    return () if $validator->has_error;

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

    return () if $validator->has_error();

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
        force      => $param->{force},
        intellect  => $param->{intellect},
        leadership => $param->{leadership},
        popular    => $param->{popular},
        loyalty    => $param->{loyalty},
        update_time => time,
      },
      weapon => $equipments_status,
      guard  => $equipments_status,
      book   => $equipments_status,
    };

    $class->model('Player')->regist($player_info);
  }

}

1;
