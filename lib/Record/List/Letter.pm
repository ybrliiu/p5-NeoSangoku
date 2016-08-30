package Record::List::Letter {
  
  use Record;
  use Mouse;
  extends 'Record::List';
  
  __PACKAGE__->meta->make_immutable();
}

1;

