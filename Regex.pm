#
# DESCRIPTION
#  Tie::Hash::Regex is a Perl object that implements a hash which allows
#  regex matching on key lookups.
#
# AUTHOR
#   Dave Cross   <dave@mag-sol.com>
#
# COPYRIGHT
#   Copyright (C) 2001, Magnum Solutions Ltd.  All Rights Reserved.
#
#   This script is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
# $Id: Regex.pm,v 0.8 2002/07/28 20:31:28 dave Exp dave $
#
# $Log: Regex.pm,v $
# Revision 0.8  2002/07/28 20:31:28  dave
# Applied "exists" hash from Steffen M�ller.
#
# Revision 0.7  2002/07/12 18:37:09  dave
# Corrected Attribute::Handler dependencies
#
# Revision 0.6  2001/12/09 19:08:31  dave
# Doc fixes.
#
# Revision 0.5  2001/12/09 19:06:36  dave
# Added Attribute::Handlers interface.
#
# Revision 0.4  2001/09/03 19:54:35  dave
# Minor fixes.
#
# Revision 0.3  2001/09/02 18:09:09  dave
# Added ref to Tie::RegexpHash.
#
# Revision 0.2  2001/06/03 17:57:26  dave
# Put into RCS.
#
#

package Tie::Hash::Regex; 

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK);

require Exporter;
require Tie::Hash;
use Attribute::Handlers autotie => { __CALLER__::Regex => __PACKAGE__ };

@ISA = qw(Exporter Tie::StdHash);
@EXPORT = qw();
@EXPORT_OK =();

$VERSION = sprintf "%d.%02d", '$Revision: 0.8 $ ' =~ /(\d+)\.(\d+)/;

sub FETCH {
  my $self = shift;
  my $key = shift;

  my $is_re = (ref $key eq 'Regexp');

  return $self->{$key} if !$is_re && exists $self->{$key};

  $key = qr/$key/ unless $is_re;

  # NOTE: wantarray will _never_ be true when FETCH is called
  #       using the standard hash semantics. I've put that piece
  #       of code in for people who are happy using syntax like:
  #       tied(%h)->FETCH(qr/$pat/);
  if (wantarray) {
    return @{$self}{ grep /$key/, keys %$self };
  } else {
    /$key/ and return $self->{$_} for keys %$self;
  }

  return;
}

sub EXISTS {
  my $self = shift;
  my $key = shift;

  my $is_re = (ref $key eq 'Regexp');

  return 1 if !$is_re && exists $self->{$key};

  $key = qr/$key/ unless $is_re;

  /$key/ && return 1 for keys %$self;

  return;
}

sub DELETE {
  my $self = shift;
  my $key = shift;

  my $is_re = (ref $key eq 'Regexp');

  return delete $self->{$key} if !$is_re && exists $self->{$key};

  $key = qr/$key/ unless $is_re;

  for (keys %$self) {
    if (/$key/) {
      delete $self->{$_};
    }
  }
}

1;
__END__

=head1 NAME

Tie::Hash::Regex - Match hash keys using Regular Expressions

=head1 SYNOPSIS

  use Tie::Hash::Regex;
  my %h;

  tie %h, 'Tie::Hash::Regex';

  $h{key}   = 'value';
  $h{key2}  = 'another value';
  $h{stuff} = 'something else';

  print $h{key};  # prints 'value'
  print $h{2};    # prints 'another value'
  print $h{'^s'}; # prints 'something else'

  print tied(%h)->FETCH(k); # prints 'value' and 'another value'

  delete $h{k};   # deletes $h{key} and $h{key2};

or (new! improved!)

  my $h : Regex;

=head1 DESCRIPTION

Someone asked on Perlmonks if a hash could do fuzzy matches on keys - this
is the result.

If there's no exact match on the key that you pass to the hash, then the
key is treated as a regex and the first matching key is returned. You can
force it to leap straight into the regex checking by passing a qr'ed
regex into the hash like this:

  my $val = $h{qr/key/};

C<exists> and C<delete> also do regex matching. In the case of C<delete>
I<all> vlaues matching your regex key will be deleted from the hash.

One slightly strange thing. Obviously if you give a hash a regex key, then
it's possible that more than one key will match (consider c<$h{qw/./}>).
It might be nice to be able to do stuff like:

  my @vals = $h{$pat};

to get I<all> matching values back. Unfortuately, Perl knows that a given
hash key can only ever return one value and so forces scalar context on
the C<FETCH> call when using the tied interface. You can get round this
using the slightly less readable:

  my @vals = tied(%h)->FETCH($pat);

=head2 ATTRIBUTE INTERFACE

From version 0.06, you can use attributes to define your hash as being tied
to Tie::Hash::Regex. You'll need to install the module Attribute::Handlers.

=head1 AUTHOR

Dave Cross <dave@dave.org.uk>

Thanks to the Perlmonks <http://www.perlmonks.org> for the original idea
and to Jeff "japhy" Pinyan for some useful code suggestions.

=head1 SEE ALSO

perl(1).

perltie(1).

Tie::RegexpHash(1)

=cut
