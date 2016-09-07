package Sangoku::Model::ForumReply {

  use Sangoku;
  use Mouse;
  with 'Sangoku::Model::Role::DB';

  use Sangoku::Util qw/validate_values datetime/;

  use constant TABLE_NAME => 'country_conference_reply';

  has 'thread_id' => (is => 'ro', isa => 'Int', required => 1);

  sub get {
    my ($self) = @_;
    my @result = $self->db->search(TABLE_NAME, {thread_id => $self->thread_id}, {order_by => 'id DESC'});
    return \@result;
  }

  __PACKAGE__->meta->make_immutable();
}

1;
