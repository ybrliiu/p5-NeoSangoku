package Record::List::Letter {
  
  use Mouse;
  extends 'Record::List'; # 継承
  
  use Record;
  
  __PACKAGE__->meta->make_immutable();
}

1;

