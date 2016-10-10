package Sangoku::DB::Row::Country::Diplomacy {

  use Sangoku;
  use parent 'Sangoku::DB::Row';

  sub start_month_and_years_num {
    my ($self) = @_;
    return $self->start_year * 100 + $self->start_month;
  }

}

1;
