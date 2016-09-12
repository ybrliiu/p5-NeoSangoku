package Sangoku::Model::Town::Guards {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Carp qw/croak/;
  use Sangoku::Model::Player;

  use constant TABLE_NAME => 'town_guards';

  has 'name' => (is => 'ro', isa => 'Str', required => 1);

  sub add {
    my ($self, $type, $player_id) = @_;

    my %where = (
      town_name => $self->name,
      player_id => $player_id,
    );

    my $order = do {
      if ($type eq 'head') {
        $self->max('order', {town_name => $self->name}) + 1;
      } elsif ($type eq 'tail') {
        $self->min('order', {town_name => $self->name}) - 1;
      } else {
        croak "$type は無効なtypeです。";
      }
    };

    $self->db->do_insert(TABLE_NAME, {%where, order => $order});

  }

  sub get {
    my ($self) = @_;
    state $player_table_name = Sangoku::Model::Player->TABLE_NAME;
    state $table_name = TABLE_NAME;

    my @columns = $self->db->search_by_sql(
      qq{SELECT * FROM $table_name, $player_table_name
        WHERE $player_table_name.id = $table_name.player_id
        AND $table_name.town_name = ?
        ORDER BY $table_name.order DESC},
      [$self->name],
      'player',
    );

    # Row::Playerオブジェクトの配列が帰ってきます
    return \@columns;
  }

  sub get_head_player {
    my ($self) = @_;
    my $max = $self->max('order', {town_name => $self->name});
    my $guards = $self->db->single(TABLE_NAME, {
      town_name => $self->name,
      order     => $max,
    });
    return Sangoku::Model::Player->get($guards->player_id);
  }

  # 以下Teng::Plugin::Functions とかにして独立させてもいいかもしれない

  sub min {
    my ($class, $column, $where, $opt) = @_;
    my ($sql, @binds) = $class->db->sql_builder->select(TABLE_NAME, [\qq{MIN("$column")}], $where, $opt);
    my ($min) = $class->db->dbh->selectrow_array($sql, {}, @binds);
    return $min;
  }

  sub max {
    my ($class, $column, $where, $opt) = @_;
    my ($sql, @binds) = $class->db->sql_builder->select(TABLE_NAME, [\qq{MAX("$column")}], $where, $opt);
    my ($max) = $class->db->dbh->selectrow_array($sql, {}, @binds);
    return $max;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
