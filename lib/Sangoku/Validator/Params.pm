package Sangoku::Validator::Params {

  use Sangoku;

  sub default_params() {
    {
      name => '名前',
      id   => 'ID',
      pass => 'パスワード',
      force      => '武力',
      intellect  => '知力',
      leadership => '統率力',
      popular    => '人望',
      loyalty => '忠誠度',
      profile => 'プロフィール',
      country_name  => '国名',
      country_color => '国色',
      confirm_rule  => 'チェックボックス',
    }
  }

}

1;
