package Record::Exception {

  use Mouse;
  extends qw/Exception::Tiny/;
  use Record;

  # 非Mouseクラス継承の際はアテリビュートを再宣言する必要がある(そもそも委譲を考慮した方がよいかも...)
  has [qw/message package subroutine/] => (is => 'ro', required => 1);
  has 'call' => (is => 'ro', isa => 'HashRef', required => 1);
  has [qw/obj/] => (is => 'ro', required => 1);

  # 非Mouseクラスを継承するために必要な処理
  sub new {
    my $class = shift;

    my $self = $class->meta->new_object(
      __INSTANCE__ => $class->SUPER::new(@_),
      @_,
    );
    return $self;
  }

  sub throw {
    my $class = shift;

    my %args;
    if (@_ == 2) {
      ($args{message}, $args{obj}) = @_;
    } else {
      %args = @_;
    }
    $args{message} = $class unless defined $args{message} && $args{message} ne '';

    # 呼び出し元の情報を格納
    my @call = (caller 1)[0 .. 3];
    my @keys = qw/package file line sub/;
    $args{call} = +{ map { $keys[$_] => $call[$_] } 0 .. 3 };

    $args{package} = caller 0;
    $args{subroutine} = (caller 2)[3];

    die $class->new(%args);
  }

  sub as_string {
    my $self = shift;
my $print = <<"EOF";
[Record::Exception]

%s at %s line %s.

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
object data:
  %s
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
EOF
    sprintf $print, $self->message, $self->call->{file}, $self->call->{line}, $self->dump;
  }

  __PACKAGE__->meta->make_immutable;
}

1;
