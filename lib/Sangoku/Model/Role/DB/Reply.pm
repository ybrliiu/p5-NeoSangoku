package Sangoku::Model::Role::DB::Reply {

  use Sangoku;
  use Mouse::Role;
  with 'Sangoku::Model::Role::DB';

  sub _additional_condition {
    my ($self) = @_;

    return () unless $self->meta->has_attribute('name');

    # if Sangoku::Model::Country::ConferenceReply
    return (country_name => $self->name);
  }

  sub get {
    my ($self) = @_;
    my @result = $self->db->search(
      $self->TABLE_NAME,
      {
        $self->_additional_condition,
        thread_id => $self->thread_id,
      },
      {order_by => 'id DESC'},
    );
    return \@result;
  }

  around 'delete' => sub {
    my ($orig, $self, $id) = @_;

    if (ref $self) {
      $self->db->delete($self->TABLE_NAME, {
        $self->_additional_condition,
        thread_id => $self->thread_id,
      });
    } else {
      $orig->($self, $id);
    }

  };

}

1;
