#!/usr/bin/perl
use utf8;
use warnings;

print "Please enter an IP address\n";
$add = <STDIN>;
chop $add;

if ( $add =~ /^((25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))\.){3}(25[0-5]|2[0-4]\d|((1\d{2})|([1-9]?\d)))/ ) {
	print "Yes, it is an IP address!\n"
} else {
	print "No, it isn't an IP address!\n"
}

