#!/usr/bin/perl -w
# rtspwalk.pl:  return valid rtsp URIs from lists of ip cameras
# 4/10/16 - chris_commat_misentropic_commercial
# usage: ./rtspwalk.pl iplist.txt || ( list_generator | ./rtspwalk.pl )
use strict;
use warnings;
use RTSP::Lite;
use File::Slurp;
my @urls = read_file( 'rtsp-urls.txt', chomp => 1 );
while (<>) {
    chomp;
    foreach my $url (@urls) {
        next if ( $url =~/^#.*$/ || $_ =~/^\s*$/ ) ;
        my $rtsp = new RTSP::Lite;
        my ( $host, $port ) = ( split /:/, $_ )[ 0, 1 ];
	$port ||= 554;
	my $req = "rtsp://${host}:${port}${url}";
        $rtsp->open( $host, $port ) or last;
        $rtsp->method("DESCRIBE");
        $rtsp->request(${req});
        my $status = $rtsp->status or next;
        print "${req}\n" if ( $status == 200 );
    }
}
