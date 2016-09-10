package Sangoku::Model::ForumReply {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB::Reply';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'forum_reply';

  has 'thread_id' => (is => 'ro', isa => 'Int', required => 1);

  sub add {
    my ($self, $args) = @_;
    validate_values($args => [qw/name icon message/]);

    $self->db->do_insert(TABLE_NAME, {
      %$args,
      thread_id => $self->thread_id,
      time      => datetime(),
    });
  }

  __PACKAGE__->meta->make_immutable();
}

1;
