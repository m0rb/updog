#!/usr/bin/perl
# dummy name server, a nameserver simulator that logs queries
# 9/27/15 - chris_commat_misentropic_dot_commercial
use strict;
use warnings;
use Net::DNS::Nameserver;
use POSIX qw(strftime);
##########CONFIG###########
my $listen = '192.168.0.1';            # a bound ipv4/ipv6 address to listen on
my $port = 53;                         # requires root privs or piping
my $ttl = 3600;                        # 1hr
my $logfile = "/var/log/dummyns.log";  # where do we log?
my $quiet = 0;                         # suppress STDOUT logging with 1
##########CONFIG###########

my $dummy = new Net::DNS::Nameserver(
	LocalAddr    => $listen,
	LocalPort    => $port,
	ReplyHandler => \&reply,
) or die "Check the configuration (or your privilege) and try again.\n";
$dummy->main_loop;

sub tp {
	open (OUT, ">>", $logfile);
	print @_ unless $quiet; print OUT @_;
	close (OUT);
}

sub reply {
	my ($qname, $qclass, $qtype, $client, $query, $conn) = @_;
	my ($rcode, @ans, @auth, @add);
	my $time = strftime "[%d/%b/%Y:%T %z]", localtime;
	tp "$client - - $time \"$qname $qclass $qtype\" - -\n";
	if ($qtype eq "A" or "AAAA") {
		my $rr = new Net::DNS::RR("$qname $ttl $qclass $qtype $listen");
		push @ans, $rr;
		$rcode = "NOERROR";
	} else {
		$rcode = "NXDOMAIN";
	}
	return ($rcode, \@ans, \@auth, \@add, { aa => 1 });
}
