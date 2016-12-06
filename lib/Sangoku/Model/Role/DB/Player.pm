package Sangoku::Model::Role::DB::Player {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Model::Country::Members;

  sub add_player_methods {
    my ($class) = @_;

    my $sql = <<"EOS";
SELECT * FROM @{[ $class->TABLE_NAME ]}
  INNER JOIN @{[ Sangoku::Model::Country::Members->TABLE_NAME ]}
  ON @{[ $class->TABLE_NAME ]}.@{[ $class->primary_key ]} = @{[ Sangoku::Model::Country::Members->TABLE_NAME ]}.player_id
EOS

    $class->meta->add_method(get_joined_to_country_members => sub {
      my ($class, $id) = @_;
      my @rows = $class->db->search_by_sql("$sql WHERE id = ?", [$id], $class->TABLE_NAME);
      return $rows[0];
    });

    $class->meta->add_method(get_all_joined_to_country_members => sub {
      my ($class) = @_;
      my @rows = $class->db->search_by_sql($sql, [], $class->TABLE_NAME);
      return \@rows;
    });

    $class->meta->add_method(search_joined_to_country_members => sub {
      my ($class, $name, $value) = @_;
      my @rows = $class->db->search_by_sql("$sql WHERE $name = ?", [$value], $class->TABLE_NAME);
      use Data::Dumper;
      warn Dumper [ map { $_->player_id } @rows ];
      return \@rows;
    });
  }

}

1;
