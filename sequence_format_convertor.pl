#!usr/bin/env perl


############################################################################################################
# This script takes GENBANK sequence flat format and CONVERTS in into FASTA format
# 
# Author: Deepak Purushotham
# usage: converter.pl inFile outFile
############################################################################################################

use strict;
use warnings;
#use Filehandle;

######################################
# Prototyping the involved subroutines
######################################

sub genbank();

my ($line,$header);
my $seq_flag = 0;


my $seq="";

#arrays for storing CDS co-ordinates
my@start;
my@end;

if( @ARGV == 0 )
{
	print "\t\t\t\t\tUsage: converter.pl inFile \n\t\t\t\t <<Please enter GENBANK sequence flat format as input>>\n";
	exit 0 ;
}

	my $input_file = $ARGV[0];
	open(FH,$input_file);


	print "File input is $input_file\n\n";
	print "Processing GENBANK File...\n";		


	my %comp;
	my $index;
		
	while (defined ($line=<FH>) )
	{
		#chomp $line;
		
		#here we will try to look for the CDS co-ordinates
			if ($line =~ /^\s+CDS/){
				if ($line =~ /(\d+)\.\.(\d+)/){
				
				my $start=$1;
				my $end=$2;
				
				my $cds_len=$end-$start;
				
				if ($cds_len < 300){
					push @start,$start;
					push @end,$end;
					
					if($line =~ /complement/)
					{
						my $index=scalar(@start);
						$index=$index-1;
						$comp{$index}=1;
					}
					else
					{
						my $index=scalar(@start);
						$index=$index-1;
						$comp{$index}=0;
					}
				}
				
			}
	}
		
	
		
		if($line =~ /^ORIGIN/) 
		{
			$seq_flag = 1;
		}
		elsif($line =~ /^VERSION\s+(\S+)\s+GI:(\S+)/) 
		{
			my $acc = $1;
			my $gi = $2;
			
			$header = ">|gi|$gi|gb|$acc|";
		}
		elsif ($seq_flag == 1 && $line =~ /\d+\s+([ACGTacgt\s+]+)/)	 
		{
			my $tmp_seq=$1;
			$tmp_seq =~ s/\s+//g;
			$seq .= $tmp_seq;
			
		}
}	

$seq =~ s/\s+$//;
$seq = uc $seq;

my $opfile = $ARGV[1];
$opfile.='.fna';
open (FILENAME, ">$opfile");	

my $s=scalar(@start);


for(my$i=0;$i<scalar(@start);$i++){
	
		print FILENAME $header."_CDS_$i\n";
		my $str = substr $seq, $start[$i], $end[$i]-$start[$i]+1;
		
		if($comp{$i} == 1)
		{
			my $comp_str=revcomp($str);
			print FILENAME $comp_str."\n";		
		}
		else
		{
			print FILENAME $str."\n";
		}
}	
				
close(FH);
close(FILENAME);

sub revcomp
{
	my ($str)=@_;
	
	my $revcomp=reverse($str);
	$revcomp =~ tr/[acgt]/[tgca]/;
	return ($revcomp);
}