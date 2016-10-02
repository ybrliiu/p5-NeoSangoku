package Sangoku::Validator::Messages {

  use Sangoku;

  sub default_messages {
    {
      not_null => '[_1]を入力してください。',
      between  => '[_1]が指定された範囲内で入力されていません。',
      length   => '[_1]が長すぎるか短すぎます。',
    }
  }

}

1;
