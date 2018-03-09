#!/usr/bin/perl
use Data::Dumper;
use feature 'say';
use warnings;

my $stripped = '?;:!,."';
sub get_biagram {
    $FILENAME = $_[0];
	open(my $inFile, '<',$FILENAME) || die "File can't open $!";
    my %word_fre;
    my %combo;
    my %pro_combo;
    my $traintext = <$inFile>;
    my @lines = split(/[\n\r]+/, $traintext);
    foreach $line (@lines) {
    	chomp $line;
	    #print "$line\n";
	    @words = split(/[\s?;:!,."]+/, lc $line);
	    @words = grep { $_ ne ''} @words;
	    push (@words, 'END');
	    unshift(@words, 'START');
	    #print "@words\n";
	    foreach my $i (0 .. ($#words - 1)) {
	    	#print "$words[$i]\n";
	    	#print "$words[$i+1]\n";
	    	#print $words[$i].' '.$words[$i+1]."\n"."\n";
	    	$w_lower_1 = $words[$i];
		    $w_lower_2 = $words[$i + 1];
		    #print "$w_lower_1\t$w_lower_2\n";
		    my $bigram_key = join '', $w_lower_1, ' ', $w_lower_2;
		   
		    $combo {$bigram_key} ++;		
		    $word_fre{$w_lower_1} ++;
	    }
    }
    #say Dumper(%combo);
    #say Dumper(%word_fre);
    foreach $key (keys %combo) {
    	$key =~ m/\s+/;
    	my $first = $`;
    	my $pro = $combo{$key} / $word_fre{$first};
    	$pro_combo{$key} = $pro;
    }
    return (\%pro_combo);
}

#======================== This is the main function. =================================#  
my ($fileIN_1) = 'HW2english.txt';
my ($en) = get_biagram($fileIN_1);
#print Dumper(%en);
#print "\n";
my ($fileIN_2) = 'HW2french.txt';
my ($fr) = get_biagram($fileIN_2);
#print Dumper($fr);
#print "\n";

my ($fileIN_3) = 'HW2german.txt';
my ($ge) = get_biagram($fileIN_3);
#print Dumper($ge);
#print "\n";

#------ get the test corpus ------#
open(my $testFile, '<', "LangID.test.txt") || die "File can't open $!";
open(my $output, '>', "BigramLetterLangId.out") || die "File can't open $!";
print $output "ID LANG\n";
my $testtext = <$testFile>;
my @rows = split(/[\n\r]+/, $testtext);
foreach my $row (@rows) {
	chomp $row;
	$row =~ m/\d+\./;
	my $linenum = $&;
	$row =~ m/\d+\.\s*/;
	@w_test = split(/[\s\r?;:!,."]+/, lc $');
	@w_test = grep { $_ ne ''} @w_test;
	#print "@w_test\n";
	push (@w_test, 'END');
	unshift(@w_test, 'START');
	#print Dumper(@w_test);
	my %sum = ("EN" => 0, "FR" => 0, "GR" => 0);
	my %langlist = ("EN" => ($en), "FR" => ($fr), "GR" => ($ge));
	foreach my $i (0 .. ($#w_test - 1)) {
		$w_low_1 = $w_test[$i];
		$w_low_2 = $w_test[$i + 1];
	    my $test_key = join '', $w_low_1, ' ', $w_low_2;
	    foreach my $lang ("EN", "FR", "GR"){
	    	if(exists($langlist{$lang}{$test_key})) {
	    		$sum{$lang} += log($langlist{$lang}{$test_key});
	    	}
	    	else{
	    		$sum{$lang} += -9999999999999;
	    	}
	    }
	}

    my $max = -99999999999999999;
    my $max_key = 0;
	foreach my $key (keys %sum) {
		if ($max < $sum{$key}) {
		 	$max_key = $key;
		 	$max = $sum{$key};
		}
	}
	print $output "$linenum $max_key\n";

}
close ($output);
close ($testFile);