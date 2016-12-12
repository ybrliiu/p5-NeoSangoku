package Sangoku::Model::ForumThread {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Thread';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'forum_thread';

  sub add {
    my ($class, $args) = @_;
    validate_values($args => [qw/title name message icon/]);

    $class->db->do_insert(TABLE_NAME, {
      %$args,
      time => datetime(),
    });
  }

  sub number_of_threads {
    my ($class) = @_;
    return $class->db->count(TABLE_NAME);
  }

  __PACKAGE__->meta->make_immutable();
}

1;
