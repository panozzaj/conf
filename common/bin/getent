#!/usr/bin/perl

use strict;
use warnings;

use Socket qw(inet_ntop);

my $database = shift @ARGV;

sub dscl_read {
    my ($path, $key) = @_;
    my $output = `dscl -q . -read $path $key 2>/dev/null`;
    if ($? != 0) {
	exit(2);
    }
    $output =~ s/^\w+:\s*(.*)\s*$/$1/m;
    return $output;
}

# name:password:uid:gid:gecos:home_dir:shell
sub getent_passwd {
    my $key = shift;
    my $path = "/Users/$key";

    print join(':', ($key,
		     'x',
		     dscl_read($path, 'UniqueID'),
		     dscl_read($path, 'PrimaryGroupID'),
		     dscl_read($path, 'RealName'),
		     dscl_read($path, 'UserShell'))),
    "\n";

    return;
}

# name:password:gid:members
sub getent_group {
    my $key = shift;
    my $path = "/Groups/$key";

    print join(':', ($key,
		     'x',
		     dscl_read($path, 'PrimaryGroupID'),
		     '')),
    "\n";

    return;
}

sub getent_hosts {
    my $key = shift;

    my ($name, $aliases, $addrtype, $length, @addrs) = gethostbyname($key);
    if (!$name) {
	exit 2;
    }
    foreach my $addr (@addrs) {
	my $a = inet_ntop($addrtype, $addr);
	printf "%-15s %s", $a, $name;
	print " $aliases" if $aliases;
	print "\n";
    }
}

if (scalar(@ARGV) == 0) {
    exit 3;
}

foreach my $key (@ARGV) {
    if ($database eq 'passwd') {
	getent_passwd $key;
    } elsif ($database eq 'group') {
	getent_group $key;
    } elsif ($database eq 'hosts') {
	getent_hosts $key;
    } else {
	print STDERR "Unknown database: $database\n";
	exit 1;
    }
}
