package Sangoku::Model::Site {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use constant TABLE_NAME => 'site';

  sub init {
    my ($class, $start_time) = @_;

    if (my $site = $class->get) {
      $site->update({
        term         => $site->term + 1,
        game_year    => 0,
        game_month   => 1,
        game_time    => 0,
        access       => 0,
        before_start => 1,
        start_time   => $start_time,
        unite_flag   => 0
      });
    } else {
      $class->db->do_insert(TABLE_NAME, {
        id         => 0,
        start_time => $start_time,
      });
    }
  }

  sub get {
    my ($class) = @_;
    return $class->db->single(TABLE_NAME, {id => 0});
  }

}

1;
