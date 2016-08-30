package Record::List {
  
  use Record;
  use Mouse;
  with 'Record::Base';
  
  has 'data' => (is => 'rw', isa => 'ArrayRef', lazy => 1, builder => '_build_data');
  # dataの最大数
  has 'max' => (is => 'ro', isa => 'Int', required => 1);
  
  sub _build_data { [] }
  
  # データ取得
  sub get {
    my ($self, $num) = @_;
    my @result = @{ $self->data };
    splice(@result, $num);
    return \@result;
  }
  
  # データ追加
  sub add {
    my ($self, $data) = @_;
    my $tmp = $self->data;
    unshift(@$tmp, $data);
    $self->data($tmp);
    return $self;
  }
  
  # 書き込み前の処理
  before 'close' => sub {
    my $self = shift;
    splice(@{ $self->data }, $self->max);
  };
  
  __PACKAGE__->meta->make_immutable();
}

1;
