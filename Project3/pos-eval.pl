#! /usr/bin/perl

use strict;

################################################################################
# POS Accuracy Evaluation
################################################################################
# Simple accuracy evaluation comparing gold and predicted POS tags.
# Arguments are two files, one gold and one predicted. Both consist of two tab
# separated columns for <word> and <tag>.
################################################################################

# argument handling
my $argc  = @ARGV;
die "Usage: $0 <gold> <predicted>\n"
    if ($argc != 2);
my $gold  = $ARGV[0];
my $pred = $ARGV[1];
my $allPOS = 0;
my $matchPOS=0;

open (G,"$gold") || die "can't find the file $gold\n";
open (P,"$pred") || die "can't find the file $pred\n";

while (my $gline=<G>){
 my $pline=<P>;
  chomp($gline);
  chomp($pline);
  my ($gword, $gtag)=split(/\t/,$gline);
  my ($pword, $ptag)=split(/\t/,$pline);
  
  if ($gword ne $pword){
    die "Gold/Predicted file mismatch:\n\tGold: $gline\n\tPred: $pline\n";
  }else{
    if ($gword ne ""){
      $allPOS++;
      if ($gtag eq $ptag){
	$matchPOS++;
      }
    }
  }
}

printf "POS Accuracy = $matchPOS / $allPOS = %3.2f%%\n", ($matchPOS / $allPOS)*100;

close (P);
close (G);

################################################################################
