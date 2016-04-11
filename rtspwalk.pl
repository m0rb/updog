#!/usr/bin/perl -w
# rtspwalk.pl:  return valid rtsp URIs from lists of ip cameras
# 4/10/16 - chris_commat_misentropic_commercial
# usage: ./rtspwalk.pl iplist.txt || ( list_generator | ./rtspwalk.pl )
use strict;
use warnings;
use RTSP::Lite;
use File::Slurp;
use Getopt::Long;
use Parallel::ForkManager;
my ( $t, $to ) = 10;
GetOptions(
    't|threads=i' => \$t,
    's|timeout=i' => \$to,
);
my @urls = read_file( 'rtsp-urls.txt', chomp => 1 );
my $lulz = Parallel::ForkManager->new($t);

STEP:
foreach my $input (<>) {
    $lulz->start and next STEP;
    chomp $input;
    my $rtsp = new RTSP::Lite;
    $rtsp->{timeout} = $to;
    foreach my $url (@urls) {
        next if ( $url =~ /^#.*$/ || $input =~ /^\s*$/ );
        my ( $host, $port ) = ( split /:/, $input )[ 0, 1 ];
        $port ||= 554;
        my $req = "rtsp://${host}:${port}${url}";
        $rtsp->open( $host, $port ) or last;
        $rtsp->method("DESCRIBE");
        $rtsp->request( ${req} );
        my $status = $rtsp->status or next;
        print "${req}\n" and last
          if ( $status eq 200 );
    }
    $lulz->finish;
}
$lulz->wait_all_children;
