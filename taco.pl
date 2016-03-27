#!/usr/bin/perl -w
# taco.pl - DM yourself, receive a shortened t.co URL
# usage: ./taco.pl http://example.com
#
# 3/26/16 - chris_commat_misentropic_commercial
use warnings;
use strict;
use Net::Twitter;

my $nt = Net::Twitter->new(
traits   => [qw/API::RESTv1_1/],
          consumer_key        => '',
          consumer_secret     => '',
          access_token        => '',
          access_token_secret => '',
          ssl => '1',
);

die unless $nt->authorized;
# note: you'll need to swap out the example user_id with your own.
my $t = $nt->new_direct_message({ user_id => 12345678, text => @ARGV });
print "$t->{entities}{urls}[0]{url}\n";
