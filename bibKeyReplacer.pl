#!/usr/bin/perl
#usage: cat *.bib|~/vishvas/progs/perl/progs/bibKeyMaker.pl>tmp
#cat *.bib>>tmp
#cat tmp|~/vishvas/progs/perl/progs/bibKeyReplacer.pl

use strict;
use warnings;

my @keys;
while(<>){
    last if($_ =~ /^@/);
    my $key = $_;
    $key =~ s/\s$//;
    $keys[++$#keys]=$key;
}
my $keyCount = 0;
do{
    if($_ =~ /^@/) {
        $_ =~ s/{.*,/{$keys[$keyCount++],/;
    }
    print $_;
}while(<>);

