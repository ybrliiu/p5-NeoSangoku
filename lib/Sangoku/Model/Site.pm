package Sangoku::Model::Site {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::RecordSingle';

  use Try::Tiny;
  use Sangoku::API::Site;

  use constant CLASS => 'Sangoku::API::Site';

  sub init {
    my ($class, $start_time) = @_;

    eval {
      my $record = $class->record->open('LOCK_EX');
      my $site = $record->at(0);
      $site->term($site->term + 1);
      $site->start_time($start_time);
      $record->close();
    };

    if (my $e = $@) {
      if (Record::Exception->caught($e)) {
        my $record = $class->record;
        $record->make();
        my $site = CLASS->new(start_time => $start_time);
        $record->open('LOCK_EX');
        $record->add($site);
        $record->close();
      }
    }

  }

  sub get {
    my ($class) = @_;
    return $class->record->open->at(0);
  }

}

1;
