package Record::Exception {

  use Record;
  use Mouse;
  extends qw/Exception::Tiny/;

  use Carp qw/confess/;

  # 非Mouseクラス継承の際はアテリビュートを再宣言する必要がある(そもそも委譲を考慮した方がよいかも...)
  has [qw/message package file line/] => (is => 'ro', isa => 'Str', required => 1);
  has [qw/call_package call_file call_line call_sub trace/] => (is => 'ro', isa => 'Str', required => 1);
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

    # unlock when locked.(lockしぱなっしだと他のfhからアクセスできなくなってしまう)
    $args{obj}->close() if $args{obj}->fh;

    ($args{package}, $args{file}, $args{line}) = caller(0);
    ($args{call_package}, $args{call_file}, $args{call_line}, $args{call_sub}) = caller(1);

    # trace
    eval { confess 'trace start' };
    $args{trace} = $@;

    die $class->new(%args);
  }

  sub as_string {
    my $self = shift;
    my $class = ref $self;

    require Data::Dumper;
    local $Data::Dumper::Maxdepth = 2;
    # 英文字以外が文字化けしないように
    no warnings 'redefine';
    local *Data::Dumper::qquote = sub { shift };
    local $Data::Dumper::Useperl = 1;

    my $format = <<"EOF";
[%s]

%s at %s line %s.
  %s called at %s line %s.

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Trace:
  %s
Object data:
  %s
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
EOF
    sprintf $format => (
      $class,
      $self->{message}, $self->{file}, $self->{line},
      $self->{call_sub}, $self->{call_file}, $self->{call_line},
      $self->{trace},
      Data::Dumper::Dumper($self->{obj}),
    );
  }

  __PACKAGE__->meta->make_immutable;
}

1;
