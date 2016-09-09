package Sangoku::Model::Country::Diplomacy {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Carp qw/croak/;
  use Sangoku::Util qw/validate_values/;

  use constant TABLE_NAME => 'country_diplomacy';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

  sub get_diplomacy_state {
    my ($self) = @_;
    my @columns = $self->db->search_by_sql(
      "SELECT * FROM @{[ TABLE_NAME ]}
        WHERE receive_country = ? OR request_country = ?",
      [$self->name, $self->name]
    );
    return \@columns;
  }

  sub can_invation {
    my ($self, $country_name, $month_and_years_num) = @_;

    {
      my @columns = $self->db->search_by_sql(
        "SELECT * FROM @{[ TABLE_NAME ]}
          WHERE type = 'cession-or-accept-territory'
          AND (receive_country = ? OR request_country = ?)",
        [$self->name, $self->name]
      );
      return 1 if @columns;
    }

    {
      my @columns = $self->db->search_by_sql(
        "SELECT * FROM @{[ TABLE_NAME ]}
          WHERE type = 'war'
          AND (receive_country = ? OR request_country = ?)",
        [$self->name, $self->name]
      );
      return 0 unless @columns;
      my $diplomacy = $columns[0]; 
      return $diplomacy->start_month_and_years_num <= $month_and_years_num; 
    }

  }

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/type receive_country start_year start_month/]);

    croak '自国に外交要請を送ることはできません。' if $self->name eq $args->{receive_country};

    my $exists_diplomacy = $self->get({
      type            => $args->{type},
      receive_country => $self->name,
      request_country => $args->{receive_country},
    });

    if (!$exists_diplomacy) {
      $self->db->do_insert(TABLE_NAME, {
        %$args,
        request_country => $self->name,
      });
    } else {
      croak '既に相手国から要請/布告が来ています。';
    }

  }

  sub get {
    my ($class, $args) = @_;
    validate_values($args => [qw/type receive_country request_country/]);
    return $class->db->single(TABLE_NAME, $args);
  }

  sub delete {
    my ($class, $args) = @_;
    validate_values($args => [qw/type receive_country request_country/]);
    $class->db->delete(TABLE_NAME, $args);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
