#!/usr/bin/perl
print "Please enter a number:\n";
$x = <STDIN>;
chop $x;

my $sum = 0;

if ( $x =~ /^[0-9]+/ ) {
	my @arr = split //, $x;
    foreach $a (@arr) {
	$sum += $a;
   }
   print "The sum is $sum.\n";
}else {
	print "It isn't a number.\n";
}
