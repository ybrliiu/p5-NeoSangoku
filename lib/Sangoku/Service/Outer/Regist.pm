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
    my @is_input_country_form = grep { $args->{"country_$_"} } qw/name color/;
    if ($town->country_name eq '無所属' || @is_input_country_form) {

      # validate country info
      {
        # number_for_validation -> nfv
        my $nfv = Sangoku::DB::Row::Country->CONSTANTS;
        my $country_color = Sangoku::DB::Row::Country->COLOR;

        $validator->set_message('country_name.length' => "[_1]は$nfv->{NAME_LEN_MIN}文字以上$nfv->{NAME_LEN_MAX}文字以下で入力してください。");
        $validator->set_message('country_color.not_null' => '[_1]を選択してください。');

        $validator->check(
          country_name  => ['NOT_NULL', [LENGTH => (1, 15)]],
          country_color => ['NOT_NULL', [CHOICE => (keys %$country_color)]],
        );

        $validator->set_error_and_message(town => (cant_build => 'その都市は既に他の国が支配しています。'))
          if $town->country_name ne '無所属';
      }

      $class->_regist_player();

    } else {


    }

    $validator->has_error ? $txn->rollback : $txn->commit;
    return $validator;
  }

  sub _regist_player {
    my ($class, $args) = @_;
  }

}

1;
