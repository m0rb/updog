#!/usr/bin/perl -w
# Usage: './simple_dns.pl domains.txt' || 'domain_generator | ./simple_dns.pl'
# Unresolvable domains will have a comment prefixed.
# inspired by @da_667's simple_dns.sh
use strict;
use warnings;
use Socket;
while (<>) {
chomp; my @addr = gethostbyname($_) or print "#$_\n";
@addr = map { inet_ntoa($_) } @addr[ 4 .. $#addr ];
foreach (@addr) { print "$_\n"; }
}
