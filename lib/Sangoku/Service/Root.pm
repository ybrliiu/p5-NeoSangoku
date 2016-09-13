package Sangoku::Service::Root {

  use Sangoku;

  use Sangoku::Model::Site;
  use Sangoku::Model::LoginList;
  use Sangoku::Model::Announce;
  use Sangoku::Model::MapLog;
  use Sangoku::Model::HistoryLog;

  sub root {
    my ($class) = @_;

    my $site = Sangoku::Model::Site->get();
    my $access = $site->access + 1;
    $site->update({access => $access});

    return {
      term         => $site->term,
      access       => $access,
      login_people => scalar @{ Sangoku::Model::LoginList->get_all },
      announce     => Sangoku::Model::Announce->get(15),
      map_log      => Sangoku::Model::MapLog->get(50),
      history_log  => Sangoku::Model::HistoryLog->get(50),
    };
  }

}

1;
