#!/usr/bin/perl
use Data::Dumper;
use feature 'say';
use warnings;

my $stripped = '?;:!,."';

#===============================================================================#
sub get_trigram {
	my $FILENAME = shift;
	my ($gt_combo, $gt_count) = @_;
    #$FILENAME = $_[0];
	open(my $inFile, '<',$FILENAME) || die "File can't open $!";
 
    my %word_fre;
    my %tri_combo;
    my %bi_combo;
    my %tri_fre_fre;
    my %bi_fre_fre;

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
	    foreach my $i (0 .. ($#words - 2)) {
	    	my $w_lower_1 = $words[$i];
		    my $w_lower_2 = $words[$i + 1];
            my $w_lower_3 = $words[$i + 2];
		    #print "$w_lower_1\t$w_lower_2\n";
		    my $trigram_key = join '', $w_lower_1, ' ', $w_lower_2, ',', $w_lower_3;	
		    my $bigram_key = join '', $w_lower_1, ' ', $w_lower_2;	   
		    $tri_combo{$trigram_key} ++;
		    $bi_combo{$bigram_key} ++;		
		    $word_fre{$w_lower_1} ++;
	    }
    }

    #=========== count the frequency of frequency =========#  
    for my $value (values %tri_combo) {
    	$tri_fre_fre{$value}++;
    }  

    for my $value (values %bi_combo) {
    	$bi_fre_fre{$value}++;
    }

    return (\%tri_combo, \%bi_combo, \%word_fre, \%tri_fre_fre, \%bi_fre_fre);
}

#======================== This is the main function. =================================#  
my $fileIN_1 = 'HW2english.txt';
my ($en_tri_combo, $en_bi_combo, $en_fre, $en_tri_count, $en_bi_count) = get_trigram($fileIN_1);

my $fileIN_2 = 'HW2french.txt';
my ($fr_tri_combo, $fr_bi_combo, $fr_fre, $fr_tri_count, $fr_bi_count) = get_trigram($fileIN_2);

my $fileIN_3 = 'HW2german.txt';
my ($ge_tri_combo, $ge_bi_combo, $ge_fre, $ge_tri_count, $ge_bi_count) = get_trigram($fileIN_3);

my %pro_tri_combo = ("EN" => $en_tri_combo, "FR" => $fr_tri_combo, "GR" => $ge_tri_combo);
my %pro_bi_combo = ("EN" => $en_bi_combo, "FR" => $fr_bi_combo, "GR" => $ge_bi_combo);
my %pro_fre = ("EN" => $en_fre, "FR" => $fr_fre, "GR" => $ge_fre);
my %pro_tri_count = ("EN" => $en_tri_count, "FR" => $fr_tri_count, "GR" => $ge_tri_count);
my %pro_bi_count = ("EN" => $en_bi_count, "FR" => $fr_bi_count, "GR" => $ge_bi_count);

#------ get the test corpus ------#
open(my $output, '>', "TrigramWordLangId-KBO.out") || die "File can't open $!";
print $output "ID LANG\n";

my $r = 5;
open(my $testFile, '<', "LangID.test.txt") || die "File can't open $!";
my $testtext = <$testFile>;
my @rows = split(/[\n\r]+/, $testtext);
foreach my $row (@rows) {
	my %test_tri_combo;
	my %test_bi_combo;
	my %sum = ("EN" => 0, "FR" => 0, "GR" => 0); 
	chomp $row;
	$row =~ m/\d+\./;
	my $linenum = $&;
	$row =~ m/\d+\.\s*/;
	my @w_test = split(/[\s\r?;:!,."]+/, lc $');
	@w_test = grep { $_ ne ''} @w_test;
	#print "@w_test\n";
	push (@w_test, 'END');
	unshift(@w_test, 'START');
	#print Dumper(@w_test);

	 foreach my $i (0 .. ($#w_test - 2)) {
	    my $w_low_1 = $w_test[$i];
		my $w_low_2 = $w_test[$i + 1];
		my $w_low_3 = $w_test[$i + 2];
		my $tri_key = join '', $w_low_1, ' ', $w_low_2, ',', $w_low_3;	
		my $bi_key_1 = join '', $w_low_1, ' ', $w_low_2;	   
		$test_tri_combo{$tri_key} ++;
		$test_bi_combo{$bi_key_1} ++;		
	   }

    foreach my $tri_key (keys %test_tri_combo) {
    	$tri_key =~ m/,+/;
    	my $one_two = $`;
    	my $three = $';
        $one_two =~ m/\s+/;
    	my $one = $`;
    	my $two = $';

    	foreach my $lang ("EN", "FR", "GR") {
    		my $sum_one = 0;
            my $sum_two = 0;
            foreach my $tri (keys $pro_tri_combo{$lang}) {
            	$tri =~ m/,+/;
        	    my $tri_two = $`;
        	    if (exists ($pro_bi_combo{$lang}{$tri_two})) {
        		    my $now_fre = $pro_tri_combo{$lang}{$tri};
                    my $now_fre_plus = $now_fre + 1;
                    if (exists($pro_tri_count{$lang}{$now_fre_plus})){
                    	my $counter = $pro_tri_count{$lang}{$now_fre};
	                    my $counter_plus = $pro_tri_count{$lang}{$now_fre_plus};
	                    my $result = ($now_fre_plus * $counter_plus) / ($counter * $pro_bi_combo{$lang}{$tri_two}); 
	                    $sum_one += $result;
                    }
                    else{
                    	$sum_two += $now_fre / $pro_bi_combo{$lang}{$tri_two};
                    }
                }
                else {
                	$sum_one = $sum_one;
                }
            }

            foreach my $bi (keys %{$pro_bi_combo{$lang}}) {
        	    $bi =~ m/\s+/;
                my $first = $`;
                if (exists ($pro_fre{$lang}{$first})) {
                    my $now_fre = $pro_bi_combo{$lang}{$bi};
                    my $now_fre_plus = $now_fre + 1;
                    if (exists($pro_bi_count{$lang}{$now_fre_plus})){
                    	my $counter = $pro_bi_count{$lang}{$now_fre};
	                    my $counter_plus = $pro_bi_count{$lang}{$now_fre_plus};
	                    my $result = ($now_fre_plus * $counter_plus) / ($counter * $pro_fre{$lang}{$first}); 
	                    $sum_two += $result;
                    }
                    else{
                    	$sum_two += $now_fre / $pro_fre{$lang}{$first};
                    }   
                }
                else {
                	$sum_two = $sum_two;
                }
            }

            my $bi_key = join '', $two, ' ', $three;
    		if (exists ($pro_tri_combo{$lang}{$tri_key})) {
                my $fre = $pro_tri_combo{$lang}{$tri_key};
                my $fre_fre = $pro_tri_count{$lang}{$fre};
                my $fre_plus = $fre + 1;
                if ($fre_fre >= $r) {
                	 $sum{$lang} += log ($fre / $pro_bi_combo{$lang}{$one_two});
                }
                else {
                	if (exists ($pro_tri_count{$lang}{$fre_plus})) {
                		my $fre_fre_plus = $pro_tri_count{$lang}{$fre_plus};
                		$sum{$lang} += log ((($fre + 1) * $fre_fre_plus) / ($pro_bi_combo{$lang}{$one_two} * $fre_fre));
                	}
                	else {
                		$sum{$lang} += log ($fre / $pro_bi_combo{$lang}{$one_two});
                    }   
                }                	
    		}
    		elsif ((exists($pro_bi_combo{$lang}{$bi_key})) && (exists($pro_fre{$lang}{$three}))) {
                
    			my $alpha = (1 - $sum_one) / (1 - $sum_two);

            	my $fre = $pro_bi_combo{$lang}{$bi_key};
            	my $fre_fre = $pro_bi_count{$lang}{$fre};
            	my $fre_plus = $fre + 1;
            	if (exists ($pro_bi_count{$lang}{$fre_plus})) {
            		my $fre_fre_plus = $pro_bi_count{$lang}{$fre_plus};
            		$sum{$lang} += log ( $alpha * ((($fre + 1) * $fre_fre_plus) / ($pro_fre{$lang}{$two} * $fre_fre)));
            	}
    		}

            elsif (exists($pro_fre{$lang}{$three})) {
    			my $appear_once = 1;
    			$sum{$lang} += log ($pro_bi_count{$lang}{$appear_once} / $pro_fre{$lang}{$three});
    		}

    		else {
    			$sum{$lang} += -999999999;
    	    }
        }
       #print Dumper(%sum);
    }
        
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
