# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..8\n"; }
END {print "not ok 1\n" unless $loaded;}
use Tie::Hash::Regex;
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

my %hash;

tie %hash, 'Tie::Hash::Regex';

$hash{key} = 'value';
$hash{key2} = 'another value';
$hash{stuff} = 'something else';

my $x = 'f';

print $hash{key} eq 'value' ? '' : 'not ', "ok 2\n";
print $hash{'^s'} eq 'something else' ? '' : 'not ', "ok 3\n";
print defined $hash{blah} ? 'not ' : '', "ok 4\n";
print $hash{$x} eq 'something else' ? '' : 'not ', "ok 5\n";

my @vals = tied(%hash)->FETCH(k);
print @vals == 2 ? '' : 'not ', "ok 6\n";
delete $hash{f};
print keys %hash == 2 ? '' : 'not ', "ok 7\n";

delete $hash{y};
print keys %hash ? 'not ' : '', "ok 8\n";

