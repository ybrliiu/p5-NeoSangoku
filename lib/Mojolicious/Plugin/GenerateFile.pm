package Mojolicious::Plugin::GenerateFile {

  use Mojo::Base 'Mojolicious::Plugin';

  use Carp qw/croak/;
  use Config::PL;
  use Path::Tiny;

  use constant HISTORY_FILE => 'generate_file.db';

  has 'store_path';
  has 'watch_files'  => sub { [] };
  has 'process_list' => sub { {} };

  sub register {
    my ($self, $app) = @_;
    $app->helper(generate_file => sub {
      my $c = shift;
      return __PACKAGE__->new(@_);
    });
  }

  sub set_process {
    my ($self, $file_name, $callback) = @_;
    croak "few arguments to subroutine (@_) " if @_ < 3;
    croak "please specify coderef" unless ref $callback eq 'CODE';

    $self->{process_list}{$file_name} = $callback;
    return $self;
  }

  sub generate {
    my ($self) = @_;

    # load history data
    my $history_file_path = $self->{store_path} . HISTORY_FILE;
    my $history_file      = path( $history_file_path );
    unless ( $history_file->exists ) {
      $history_file->touch;
      $history_file->spew_utf8("{}");
    }
    my $history      = config_do( $history_file_path );
    my $history_data = <<"EOS";
# manege file of generate file from perl
# this file is generated by @{[ __PACKAGE__ ]}. Don't edit this file;

use utf8;
{
EOS

    # edit files
    my @watch_files_mtime = map { path( $_ )->stat->mtime } @{ $self->{watch_files} };
    while ( my ($key, $value) = each %{ $self->{process_list} } ) {
      my $last_update_time = $history->{$key}{mtime} // 0;
      my $file             = path( $self->{store_path} . $key );
      if ( $last_update_time < $file->stat->mtime
          || grep { $last_update_time < $_ } @watch_files_mtime ) {
        $file->touch unless $file->exists;
        $file->spew_utf8( $value->() );
      }
      $history_data .= <<"EOS";
  '$key' => {
    name  => '$key',
    mtime => @{[ $file->stat->mtime ]},
  },
EOS
    }
    
    # save history
    $history_data .= "\n} \n";
    $history_file->spew_utf8( $history_data );
  }

}

1;
