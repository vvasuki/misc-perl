#!/usr/bin/perl -w
use strict;
use warnings;
print "mass renamer in action\n";
print "please enter the directory whose contents are to be renamed to *.txt...
/books/tmp is the default
";
my $dir=<>;
$dir="/books/tmp\n" if($dir =~ /^$/);
$dir =~ s/\n/\//;
die "will only work on the contents /books\n" if($dir !~ /\/books/);
#print "$dir\n";
# directory operations
opendir DIR, $dir || die "canst not open the directory $!, lord";
my @dirFiles=readdir DIR;
#print "@dirFiles\n";
closedir DIR;

foreach(@dirFiles)
{
next if($_ =~/.txt/);
print "rename ".$dir.$_." ".$dir.$_.".txt\n";
rename $dir.$_,$dir.$_.".txt";
}


exit;

