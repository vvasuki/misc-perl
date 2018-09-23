#!/usr/bin/perl -w
use strict;
use warnings;
print "mass txt2lit in action\n";
print "please enter the directory whose *.txt contents are to be converted to *.lit...
/books/tmp is the default
";
my $dir=<>;
$dir="/books/tmp\n" if($dir =~ /^$/);
$dir =~ s/\n/\//;
#die "will only work on the contents /books\n" if($dir !~ /\/books/);
#print "$dir\n";
# directory operations
opendir DIR, $dir || die "canst not open the directory $!, lord";
my @dirFiles=readdir DIR;
#print "@dirFiles\n";
closedir DIR;

foreach(@dirFiles)
{
next if($_ !~/.txt/);
$_ =~ s/.txt//;
print "convert ".$dir.$_.".txt ".$dir.$_.".lit\n";
system "wine /books/dosApps/misc/txt2lit/txt2lit -t\"$_\" \"z:$dir$_.txt\" \"z:$dir$_.lit\"";
}


exit;

