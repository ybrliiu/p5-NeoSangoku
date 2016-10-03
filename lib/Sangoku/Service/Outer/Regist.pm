package Sangoku::Service::Outer::Regist {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use List::Util qw/sum/;
  use Sangoku::Util qw/validate_values/;
  use Sangoku::DB::Row::Player;
  use Sangoku::DB::Row::Country;
  use Sangoku::Model::IconList;

  sub root {
    my ($class) = @_;

    my $towns = $class->model('Town')->get_all();

    return {
      %{ Sangoku::DB::Row::Player->CONSTANTS },
      ABILITY_LIST  => Sangoku::DB::Row::Player->ABILITY_LIST,
      COUNTRY_COLOR => Sangoku::DB::Row::Country->COLOR,
      COUNTRY_NAME_LEN_MIN => Sangoku::DB::Row::Country->CONSTANTS->{NAME_LEN_MIN},
      COUNTRY_NAME_LEN_MAX => Sangoku::DB::Row::Country->CONSTANTS->{NAME_LEN_MAX},
      towns => $towns,
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
      my $nfv = Sangoku::DB::Row::Player->CONSTANTS;
      $nfv->{ABILITY_MAX} = 100;
      $nfv->{ABILITY_MIN} = 1;
      $nfv->{ABILITY_SUM} = 160;
      my $ability_list = Sangoku::DB::Row::Player->ABILITY_LIST;

      $validator->set_message('id.length' => "[_1]は$nfv->{ID_LEN_MIN}文字以上$nfv->{ID_LEN_MAX}文字以下で入力してください。");
      $validator->set_message('pass.length' => "[_1]は$nfv->{PASS_LEN_MIN}文字以上$nfv->{PASS_LEN_MAX}文字以下で入力してください。");
      $validator->set_message('confirm_rule.equal' => '規約に同意できない場合は登録できません。');

      my %ability_check = map { $_ => ['NOT_NULL', [BETWEEN => ($nfv->{ABILITY_MIN}, $nfv->{ABILITY_MAX})]] } @$ability_list;
      $validator->check(
        name => ['NOT_NULL', [LENGTH => ($nfv->{NAME_LEN_MIN}, $nfv->{NAME_LEN_MAX})]],
        icon => ['NOT_NULL', [BETWEEN => (0, Sangoku::Model::IconList->MAX)]],
        town => ['NOT_NULL'],
        id   => ['NOT_NULL', 'ASCII', [LENGTH => ($nfv->{ID_LEN_MIN}, $nfv->{ID_LEN_MAX})]],
        pass => ['NOT_NULL', 'ASCII', [LENGTH => ($nfv->{PASS_LEN_MIN}, $nfv->{PASS_LEN_MAX})]],
        %ability_check,
        loyalty => ['NOT_NULL', [LENGTH => ($nfv->{LOYALTY_MIN}, $nfv->{LOYALTY_MAX})]],
        profile => [[LENGTH => (0, $nfv->{PROFILE_LEN_MAX})]],
        mail    => ['ASCII', [LENGTH => (0, $nfv->{MAIL_LEN_MAX})]],
        confirm_rule => ['NOT_NULL', [EQUAL => 1]],
      );

      $validator->set_error_and_message(pass => (same => 'IDとパスワードは同じにできません！'))
        if $args->{pass} eq $args->{id};

      my $ability_sum = sum map { $args->{$_} || 0 } @$ability_list;
      $validator->set_error_and_message('ability' => (sum => "能力の合計値は$nfv->{ABILITY_SUM}になるようにしてください！"))
        unless $ability_sum == $nfv->{ABILITY_SUM};

    }

    my $town = $class->model('Town')->get($args->{town});
    $town->refetch({for_update => 1});

    my @is_input_country_form = grep { $args->{"country_$_"} } qw/name color/;
    if ($town->can_establish_nation || @is_input_country_form) {

      # validate country info
      {
        # number_for_validation -> nfv
        my $nfv = Sangoku::DB::Row::Country->CONSTANTS;
        my $country_color = Sangoku::DB::Row::Country->COLOR;

        $validator->set_message('country_name.length' => "[_1]は$nfv->{NAME_LEN_MIN}文字以上$nfv->{NAME_LEN_MAX}文字以下で入力してください。");
        $validator->set_message('country_color.not_null' => '[_1]を選択してください。');

        $validator->check(
          country_name  => ['NOT_NULL', [LENGTH => ($nfv->{NAME_LEN_MIN}, $nfv->{NAME_LEN_MAX})]],
          country_color => ['NOT_NULL', [CHOICE => (keys %$country_color)]],
        );

        $validator->set_error_and_message(town => (cant_establish => 'その都市は既に他の国が支配しています。'))
          unless $town->can_establish_nation;
      }

      $class->_create_country({
        param     => $args,
        validator => $validator,
        town      => $town,
      });
      $class->_regist_player({
        param     => $args,
        validator => $validator,
        town      => $town,
      });
      $class->_create_country_position($args, $validator);

    } else {

      $class->_regist_player({
        param     => $args,
        validator => $validator,
        town      => $town,
      });

    }

    $validator->has_error ? $txn->rollback : $txn->commit;
    return $validator;
  }

  sub _create_country {
    my ($class, $args) = @_;
    state $keys = [qw/param validator town/];
    validate_values($args => $keys);
    my ($param, $validator, $town) = map { $args->{$_} } @$keys;

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
      king_id => $param->{name},
    });
  }

  sub _regist_player {
    my ($class, $args) = @_;
    state $keys = [qw/param validator town/];
    validate_values($args => $keys);
    my ($param, $validator, $town) = map { $args->{$_} } @$keys;
    $town->refetch();
   
    {
      my $player = $class->model('Player')->get($param->{id});
      $validator->set_error_and_message(id => 'already_exist') if defined $player;
    } 
    
    {
      my $rows = $class->model('Player')->search(name => $param->{name});
      $validator->set_error(name => 'already_exist') if @$rows;
    }

    return () if $validator->has_error();

    my $player_info = {
      id   => $param->{id},
      name => $param->{name},
      pass => $param->{pass},
      icon => $param->{icon},
      country_name => $town->country_name,
      town_name    => $town->name,
      force      => $param->{force},
      intellect  => $param->{intellect},
      leadership => $param->{leadershi},
      popular    => $param->{popular},
      loyalty    => $param->{loyalty},
      update_time => time,
    };

    $class->model('Player')->regist($player_info);
  }

}

1;
