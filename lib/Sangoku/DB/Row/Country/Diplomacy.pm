package Sangoku::DB::Row::Country::Diplomacy {

  use Mouse;
  use Sangoku;
  extends 'Sangoku::DB::Row';

  sub start_month_and_years_num {
    my ($self) = @_;
    return $self->start_year * 100 + $self->start_month;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
