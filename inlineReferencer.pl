#!/usr/bin/perl
# usage :  cat /home/vishvas/vishvas/miscInfo/healthBrain.htm | ./inlineReferencer.pl


use warnings;
use strict;

my @lines=<>;
#print @lines;

# harvest links
my %mapLinks;
foreach (@lines) {
    if($_ !~ /^<li>\[/) {
        next;
    }
    my $line = $_;
    $line =~ s/\n//;
    $line =~ s/<li>//;
    $line =~ s/<\/li>//;
    #print $line."\n";
    my ($ref, $url);
    $ref = $line;
    $ref =~ s/ .*//;
    $url = $line;
    $url =~ s/.* //;
    #print "$url==$ref\n";
    $mapLinks{$ref}=$url;
}

foreach (@lines) {
    if($_ !~ /\[.*\d*\]/) {
        print $_;
        next;
    }
    my $line = $_;
    my ($ref, $url);
    $ref = $line;
    $ref =~ s/.*(\[.*\d*\]).*/$1/;
    $ref =~ s/\n//;
    #print "$ref==\n";
    $url = $mapLinks{$ref};
    #print $url;
    $line =~ s/\[.*\d*\]/<a href="$url"> [Reference]<\/a>/;
    print $line;
}
