package Sangoku::DB::Row::Player {

  use Sangoku;
  use parent 'Teng::Row';

  use Sangoku::Model::IconList;

  use constant {
    CONSTANTS => {
      NAME_LEN_MIN => 1,
      NAME_LEN_MAX => 15,
      ID_LEN_MIN   => 6,
      ID_LEN_MAX   => 16,
      PASS_LEN_MIN => 6,
      PASS_LEN_MAX => 16,
      LOYALTY_MIN  => 0,
      LOYALTY_MAX  => 100,
      PROFILE_LEN_MAX => 1000,
      MAIL_LEN_MAX    => 40,
    },
    ABILITY_LIST => [qw/force intellect leadership popular/],
  };

  sub icon_path {
    my ($self) = @_;
    return Sangoku::Model::IconList->ICONS_DIR_PATH . $self->icon . '.gif';
  }

}

1;
