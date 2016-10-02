package Sangoku::DB::Row::Country {

  use Sangoku;
  use parent 'Teng::Row';

  use Sangoku::Util qw/load_config/;

  use constant {
    CONSTANTS => {
      NAME_LEN_MIN => 1,
      NAME_LEN_MAX => 16,
    },
    COLOR => load_config('etc/config/color.conf')->{countrycolor},
  };

}

1;
