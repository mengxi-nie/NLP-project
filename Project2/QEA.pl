#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

open (my $DATA, "<LangID.gold.txt") || die "cant open it : $!";
my $text = <$DATA>;
$text =~ s/[\r\n]+/\n/g;
#print "$text\n";
my @goldres = split("\n", $text);
shift @goldres;

my %langgold = ();

foreach my $result (@goldres){
	$result =~ s/\d+\.\s+//;
	$langgold{$result}++;
} 

my $goldlen = @goldres;
print Dumper(%langgold);
print "\n";
#print Dumper(@goldres);
#print "\n";

my @filelist = ("BigramLetterLangId", "BigramWordLangId-AO", "BigramWordLangId-GT", "TrigramWordLangId-KBO");
my %resultlist = ();
my %accuracy = ();
my %confusion = ();

foreach my $file (@filelist){
	print "$file\n";
	$confusion{$file} = {};

	open (my $f, $file.".out") || die "cant open it : $!";
	my @filerows = <$f>;
	shift @filerows;

	my $sindex = 0;
	foreach my $filerow (@filerows){
		$filerow =~ s/\d+\.\s+//;
		$filerow =~ s/\s+$//;

		if ($filerow eq $goldres[$sindex]){
			$accuracy{$file}++;
			$confusion{$file}{$goldres[$sindex]}{$filerow}++;
		}
		else{
			$confusion{$file}{$goldres[$sindex]}{$filerow}++;
		}

		$sindex++;
	} 

	$accuracy{$file} /= $goldlen;
	print "$accuracy{$file}\n";

	foreach my $fi (sort keys %{$confusion{$file}}){
		foreach my $si (sort keys %{$confusion{$file}{$fi}}){
			print "The $fi sentence is confused with $si : $confusion{$file}{$fi}{$si}\n"
		}
	}

	#print Dumper(@filerows);
	#print "\n";

} 