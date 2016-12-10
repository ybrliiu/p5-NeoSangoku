use Sangoku 'test';
use Sangoku::Util;

sub test_sub {
  my ($args) = @_;
  Sangoku::Util::validate_values($args => [qw/name id/], 'something');
}

subtest 'validate_values' => sub {
  dies_ok(sub { test_sub({}) }, 'few argments');
  is($@, "somethingの キーが足りません(name, id) at t/util.t line 10\n");
  lives_ok(sub { test_sub({name => 'people', id => '7777'}) }, 'all ok');
};

subtest 'time' => sub {
  is(Sangoku::Util::datetime(1449914400), '2015/12/12(土) 19:00:00');
};

subtest 'child_module_list' => sub {
  ok(my $list = Sangoku::Util::child_module_list('Sangoku::Model::Player'));
  ok(my @exists = grep { $_ eq 'Sangoku::Model::Player::Command' } @$list);
};

subtest 'escape-color' => sub {
  my $regex = qr/<span/;
  
  like(Sangoku::Util::escape( qq{<a href="aaa'aaa'aaa">gold</a><red>dsdsd</red>} ), $regex);
  like(Sangoku::Util::escape( qq{<a href="aaa'aaa'aaa">gold</a><red>dsdsd</red>dsdssd} ), $regex);
  like(Sangoku::Util::escape( qq{<a href="aaa'aaa'aaa">gold</a><red>dsdsd</red><red>dsdsd</red>} ), $regex);
  
  unlike(Sangoku::Util::escape( qq{<a href="aaa'aaa'aaa">gold</a><red>} ), $regex);
  unlike(Sangoku::Util::escape( qq{<a href="aaa'aaa'aaa">gold</a><red>dsdsd} ), $regex);
  unlike(Sangoku::Util::escape( qq{<a href="aaa'aaa'aaa">gold</a><red>dsdsd<red>dsdsd</red>dsdssd} ), $regex);
};

subtest 'escape-bold...etc' => sub {
  like(Sangoku::Util::escape( qq{test<b><red>test</red></b>} ), qr/<span/);
  like(Sangoku::Util::escape( qq{test<b><red>test</red></b>} ),qr/<b>/);
  unlike(Sangoku::Util::escape( qq{test<b><red>test</red>} ),qr/<b>/);
};

subtest 'escape-link' => sub {
  is(
    Sangoku::Util::escape('前の文字<a>url:http://www.google.com name:名前</a>後の文字'),
    '前の文字<a href="http://www.google.com">名前</a>後の文字',
  );
  
  unlike(Sangoku::Util::escape('前の文字<a>url:this is url name:名前'), qr/<a/);
  unlike(Sangoku::Util::escape('前の文字<a>url:this is url</a>'), qr/<a/);
  unlike(Sangoku::Util::escape('前の文字<a>くぁｓｄｆｇｈｊｋ</a>'), qr/<a/);
  
  is(
    Sangoku::Util::escape('before<a>url:www name:test</a>middle<a>url:aaa name:aaa</a>last'),
    'before<a href="www">test</a>middle<a href="aaa">aaa</a>last',
  );
  unlike(Sangoku::Util::escape('before<a>url:www name:testmiddle<a>url:aaa name:aaa</a>last<a>'), qr/<a/);
};

done_testing();
