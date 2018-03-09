#!/usr/bin/perl
use Data::Dumper;
use feature 'say';
use strict;
#use warnings;

my $stripped = '?;:!,."';


#===============================================================================#
sub get_biagram {
	my $FILENAME = shift;
    #$FILENAME = $_[0];
	open(my $inFile, '<',$FILENAME) || die "File can't open $!";
	#open(my $inFile, '<','HW2english.txt') || die "File can't open $!";
    my %word_fre;
    my %combo;
    my %count_first_combo;
    my $traintext = <$inFile>;
    my @lines = split(/[\n\r]+/, $traintext);
    foreach my $line (@lines) {
    	chomp $line;
	    #print "$line\n";
	    my @words = split(/[\s?;:!,."]+/, lc $line);
	    @words = grep { $_ ne ''} @words;
	    push (@words, 'END');
	    unshift(@words, 'START');
	    #print "@words\n";
	    foreach my $i (0 .. ($#words - 1)) {
	    	#print "$words[$i]\n";
	    	#print "$words[$i+1]\n";
	    	#print $words[$i].' '.$words[$i+1]."\n"."\n";
	    	my $w_lower_1 = $words[$i];
		    my $w_lower_2 = $words[$i + 1];
		    #print "$w_lower_1\t$w_lower_2\n";
		    my $bigram_key = join '', $w_lower_1, ' ', $w_lower_2;
		   
		    $combo {$bigram_key} ++;		
		    $word_fre{$w_lower_1} ++;
	    }
    }
    
    foreach my $key (keys %combo) {
    	$key =~ m/\s+/;
    	my $first = $`;
        $count_first_combo{$first} ++;	
    }
    #print Dumper(%count_first_combo);
    return (\%combo, \%word_fre, \%count_first_combo);
}

#======================== This is the main function. =================================#  
my $fileIN_1 = 'HW2english.txt';
my ($en_combo, $en_fre, $en_count) = get_biagram($fileIN_1);

my $fileIN_2 = 'HW2french.txt';
my ($fr_combo, $fr_fre, $fr_count) = get_biagram($fileIN_2);

my $fileIN_3 = 'HW2german.txt';
my ($ge_combo, $ge_fre, $ge_count) = get_biagram($fileIN_3);

my %pro_combo = ("EN" => ($en_combo), "FR" => ($fr_combo), "GR" => ($ge_combo));
my %pro_fre = ("EN" => $en_fre, "FR" => $fr_fre, "GR" => $ge_fre);
my %pro_count = ("EN" => $en_count, "FR" => $fr_count, "GR" => $ge_count);

#print Dumper($pro_combo{"EN"});

open(my $output, '>', "BigramWordLangId-AO.out") || die "File can't open $!";
print $output "ID LANG\n";

open(my $testFile, '<', "LangID.test.txt") || die "File can't open $!";
my $testtext = <$testFile>;
my @rows = split(/[\n\r]+/, $testtext);
foreach my $row (@rows) {
	my %test_combo;
	my %sum = ("EN" => 0, "FR" => 0, "GR" => 0); 
	chomp $row;
    $row =~ m/\d+\./;
    my $linenum = $&;
    $row =~ m/\d+\.\s*/;
    my @w_test = split(/[\s\r?;:!,."]+/, lc $');
    my @w_test = grep { $_ ne ''} @w_test;
    #print "@w_test\n";
    push (@w_test, 'END');
    unshift(@w_test, 'START');

    foreach my $i (0 .. ($#w_test - 1)) {
	    my $w_low_1 = $w_test[$i];
		my $w_low_2 = $w_test[$i + 1];
		my $AO_key = join '', $w_low_1, ' ', $w_low_2;		   
		$test_combo{$AO_key} ++;		
	   }

    foreach my $key (keys %test_combo) {
    	$key =~ m/\s+/;
    	my $first = $`;
    	foreach my $lang ("EN", "FR", "GR") {
    		if ((~exists ($pro_combo{$lang}{$key}) && (exists ($pro_fre{$lang}{$first})))) {
    			$sum{$lang} += log (1 / ($pro_fre{$lang}{$first} + $pro_count{$lang}{$first}));
    		}

    		elsif ((exists ($pro_combo{$lang}{$key}) && (exists ($pro_fre{$lang}{$first})))) {
    			$sum{$lang} += log (($pro_combo{$lang}{$key} + 1) / ($pro_fre{$lang}{$first} + $pro_count{$lang}{$first}));	
    		}

    		else {
    			$sum{$lang} += -999999999;
    	}
      }
    }
    #print Dumper(%sum);

    my $max = -999999999999999999999;
    my $max_key = 0;
	foreach my $key (keys %sum) {
		if ($max < $sum{$key}) {
		 	$max_key = $key;
		 	$max = $sum{$key};
		}
	}
	print "$linenum $max_key\n"; 
	print $output "$linenum $max_key\n"; 
}

close ($output);
close ($testFile);

