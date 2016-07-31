requires qw/perl 5.022002/;
requires qw/Mojolicious 7.0/;
requires qw/Mojolicious::Plugin::AssetPack 1.18/;
requires qw/Mouse 2.4.5/;
requires qw/Teng 0.28/;

requires qw/Exception::Tiny 0.2.1/;
requires qw/Exporter 5.72/;
requires qw/Carp 1.36/
requires qw/parent 0.232/;
requires qw/constant/;

requires qw/Encode 2.72/
requires qw/Cwd 3.56_01/;
requires qw/Time::Piece 1.29/;
requires qw/Path::Tiny 0.096/
requires qw/Config::PL 0.02/;

on test => sub {
  requires qw/Test::More/;
  requires qw/Test::Exception/;
  requires qw/Test::PostgreSQL/;
};

