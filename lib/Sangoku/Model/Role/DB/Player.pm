package Sangoku::Model::Role::DB::Player {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Model::Country::Members;

    sub _sql_of_country_members {
      my ($class) = @_;
      state $sql = {};
      return $sql->{$class} if exists $sql->{$class};
      $sql->{$class} = <<"EOS";
SELECT * FROM @{[ $class->TABLE_NAME ]}
  INNER JOIN @{[ Sangoku::Model::Country::Members->TABLE_NAME ]}
  ON @{[ $class->TABLE_NAME ]}.@{[ $class->primary_key ]} = @{[ Sangoku::Model::Country::Members->TABLE_NAME ]}.player_id
EOS
    }

    sub get_joined_to_country_members {
      my ($class, $id) = @_;
      my @rows = $class->db->search_by_sql( $class->_sql_of_country_members . " WHERE id = ?", [$id], $class->TABLE_NAME );
      return $rows[0];
    }

    sub get_all_joined_to_country_members {
      my ($class) = @_;
      my @rows = $class->db->search_by_sql( $class->_sql_of_country_members, [], $class->TABLE_NAME );
      return \@rows;
    }

    sub search_joined_to_country_members {
      my ($class, $name, $value) = @_;
      my @rows = $class->db->search_by_sql( $class->_sql_of_country_members . " WHERE $name = ?", [$value], $class->TABLE_NAME );
      return \@rows;
    }

}

1;
