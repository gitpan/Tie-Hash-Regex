# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

use Test::Simple tests=> 9;

END {print "not ok 1\n" unless $loaded;}
use Tie::Hash::Regex;
$loaded = 1;
ok($loaded);

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my %hash : Regex;

$hash{key} = 'value';
$hash{key2} = 'another value';
$hash{stuff} = 'something else';

my $x = 'f';

ok($hash{key} eq 'value');
ok($hash{'^s'} eq 'something else');
ok(not defined $hash{blah});
ok($hash{$x} eq 'something else');

my @vals = tied(%hash)->FETCH(k);
ok(@vals == 2);
delete $hash{f};
ok(keys %hash == 2);

ok(exists $hash{key});

delete $hash{y};
ok(not keys %hash);

