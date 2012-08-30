#!/usr/bin/env perl

use strict;

&GCbywindow;#prototyping a subroutine used later

#opening the genome nucleotide sequence and computing the GC content
open(GENOME, "full_genome.fasta");


my$seq;
my $line;

 while(defined ($line = <GENOME>)){
 
 	if ($line =~ /^>/){
 		next;
 	}
 	else{
 		chomp($line);
 		$line =~ s/\s+$//;
 		$seq .= $line; 
 	}
 	
 }


# declaring the subroutine for calculating the GC content
sub calc_GCcont($) {
my($seq_inp) = @_;
my$a = ($seq_inp =~ tr/A//);
my$c = ($seq_inp =~ tr/C//);
my$g = ($seq_inp =~ tr/G//);
my$t = ($seq_inp =~ tr/T//);

#print "\n\n\n";

#print "A              :  $a\n";
#print "C              :  $c\n";
#print "G              :  $g\n";
#print "T              :  $t\n";

my$total = ($a + $c + $g + $t);
my$gc = (($g+ $c)/$total)*100;
return $gc;
#print "GC Content     :  $gc\n\n\n";

} # end of subroutine

########################################

# now we will take a 1MB region 

my$oneMB = substr $seq, 0, 1000000;
my$oneMB_gc = calc_GCcont($oneMB); # this sub call will print the GC content for the whole genome

print "original GC content : $oneMB_gc \n";
#generating a random sequence with the obtained GC content

#calling sub for window by window GC content

GCbywindow($oneMB,"original");

my$rand_seq;
my$range = 100;
for (1..1000000){
	if (rand($range) < $oneMB_gc){
		$rand_seq .= (rand($range) < 50 ? 'G' : 'C');
	}
	else{
		$rand_seq .= (rand($range) < 50 ? 'A' : 'T');
	}
}

$rand_seq =~ s/\s+$//; # removing trailing spaces

my$rand_seq_GC = calc_GCcont($rand_seq); # compute GC for this sequence
print "\nGC content of the random sequence :" . $rand_seq_GC . "\n\n";

GCbywindow($rand_seq,"random");

#now calculate GC content window by window
sub GCbywindow($$){

	my($seq_inp,$genome) = @_;
	open(PLOT_FILE, '>'.$genome.'_plot.txt');

	my @windows = $oneMB =~ /(.{1000})/g;
	my$cnt=1;

	foreach(@windows){
		print PLOT_FILE $cnt . "\t";
		my$returned_gc = calc_GCcont($_);
		print PLOT_FILE $returned_gc . "\n";
		$cnt++;
	}
close(PLOT_FILE);
} # end of subroutine


close (GENOME);






