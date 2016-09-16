package Record::List::CommandList {
  
  use Record;
  use Mouse;
  extends 'Record::List';
  
  # コマンドリストデータ更新
  sub save {
    my ($self, $no, $obj) = @_;
    $self->data->[$no] = $obj;
    return $self;
  }
  
  __PACKAGE__->meta->make_immutable();
}

1;

