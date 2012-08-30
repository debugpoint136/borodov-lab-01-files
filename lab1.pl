#!/usr/bin/env perl

use strict;
$/ = undef;

#opening the uvrB nucleotide sequence and computing the GC content
open(UVRB_GENE, "uvrB_nucleotide.txt");

my$seq = <UVRB_GENE>;


my$a = ($seq =~ tr/A//);
my$c = ($seq =~ tr/C//);
my$g = ($seq =~ tr/G//);
my$t = ($seq =~ tr/T//);

print "\n\n\n";
print "A     :  $a\n";
print "C     :  $c\n";
print "G     :  $g\n";
print "T     :  $t\n";

my$total = ($a + $c + $g + $t);
my$gc = (($g+ $c)/$total)*100;

print "GC Content     :  $gc\n";

print "GC content = $gc";



