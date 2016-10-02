package Sangoku::Service::Outer::Regist {

  use Mouse;
  use Sangoku;
  with 'Sangoku::Service::Role::Base';

  use List::Util qw/sum/;

  use constant {
    ABILITY_LISTS => [qw/force intellect leadership popular/],
  };

  sub root {
    my ($class) = @_;

    my $towns = $class->model('Town')->get_all();

    return {
      towns => $towns,
      ABILITY_LISTS => ABILITY_LISTS,
    };
  }

  sub regist {
    my ($class, $args) = @_;
    my $validator = $class->validator($args);

    # $validator->set_message("force.not_null" => '[_1]は1〜160の間で入力してください。');

    {
      my %ability_check = map { $_ => ['NOT_NULL', [BETWEEN => (1, 100)]] } @{ ABILITY_LISTS() };

      $validator->check(
        name => ['NOT_NULL', [LENGTH => (1, 16)]],
        icon => ['NOT_NULL', [BETWEEN => (0, 499)]],
        town => ['NOT_NULL'],
        id   => ['NOT_NULL', [LENGTH => (6, 16)]],
        pass => ['NOT_NULL', [LENGTH => (6, 16)]],
        %ability_check,
        loyalty => ['NOT_NULL', [LENGTH => (0, 100)]],
        profile => [[LENGTH => (0, 1000)]],
        mail    => [[LENGTH => (0, 20)]],
        confirm_rule => ['NOT_NULL', [EQUAL => 1]],
      );

      $validator->set_error_and_message(pass => (same => 'IDとパスワードは同じにできません！'))
        if $args->{pass} eq $args->{id} && !($args->{id} eq '');

      my $ability_sum = sum map { $args->{$_} || 0 } @{ ABILITY_LISTS() };
      $validator->set_error_and_message('ability' => (sum => "能力の合計値は160になるようにしてください！"))
        unless $ability_sum == 160;

    }

    my $town = $class->model('Town')->get($args->{town});
    my @is_input_country_form = grep { $args->{"country_$_"} } qw/name color/;
    if ($town->country_name eq '無所属' || @is_input_country_form) {

      $validator->check(
        country_name  => ['NOT_NULL', [LENGTH => (1, 15)]],
        country_color => ['NOT_NULL'],
      );

    } else {


    }

    return $validator;
  }

}

1;
