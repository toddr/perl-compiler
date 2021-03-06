#!./perl -w

BEGIN {
    unshift @INC, 't/CORE/lib';
    require 't/CORE/test.pl';
}

watchdog(10);
plan(tests => 29);
use strict;
use vars '$x';

use Config;
my $have_alarm = $Config{d_alarm};

$x = "abc\ndef\n";
study($x);

ok($x =~ /^abc/);
ok($x !~ /^def/);

# used to be a test for $*
ok($x =~ /^def/m);

$_ = '123';
study;
ok(/^([0-9][0-9]*)/);

ok(!($x =~ /^xxx/));
ok(!($x !~ /^abc/));

ok($x =~ /def/);
ok(!($x !~ /def/));

study($x);
ok($x !~ /.def/);
ok(!($x =~ /.def/));

ok($x =~ /\ndef/);
ok(!($x !~ /\ndef/));

$_ = 'aaabbbccc';
study;
ok(/(a*b*)(c*)/);
is($1, 'aaabbb');
is($2,'ccc');
ok(/(a+b+c+)/);
is($1, 'aaabbbccc');

ok(!/a+b?c+/);

$_ = 'aaabccc';
study;
ok(/a+b?c+/);
ok(/a*b+c*/);

$_ = 'aaaccc';
study;
ok(/a*b?c*/);
ok(!/a*b+c*/);

$_ = 'abcdef';
study;
ok(/bcd|xyz/);
ok(/xyz|bcd/);

ok(m|bc/*d|);

ok(/^$_$/);

# used to be a test for $*
ok("ab\ncd\n" =~ /^cd/m);

TODO: {
    # Even with the alarm() OS/390 and BS2000 can't manage these tests
    # (Perl just goes into a busy loop, luckily an interruptable one)
    todo_skip('busy loop - compiler bug?', 2)
	      if $^O eq 'os390' or $^O eq 'posix-bc';

    # [ID ] tests 25..26 may loop

    $_ = 'FGF';
    study;
    ok(!/G.F$/, 'bug 20010618.006');
    ok(!/[F]F$/, 'bug 20010618.006');
}
