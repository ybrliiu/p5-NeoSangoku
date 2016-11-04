package Sangoku::DB::Row::Role::Player::Equipment {

  use Mouse::Role;
  use Sangoku;

  use Sangoku::Util qw/validate_values/;

  use constant NAME_LEN_MAX => 15;

  sub validate_name {
    my ($class ,$validator, $args) = @_;
    $class = ref $class || $class;
    # $form_name is weapon_name , ...
    my $form_name = lc((split /::/, $class)[-1]) . '_name';
    validate_values($args => [$form_name]);

    $validator->set_message("$form_name.length" => "[_1]は" . NAME_LEN_MAX . "文字以下で入力してください。");
    $validator->check($form_name => [[LENGTH => (0, NAME_LEN_MAX)]]);
  }

}

1;
