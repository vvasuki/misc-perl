#!/usr/bin/perl -w
use strict;
use warnings;
print "mass renamer in action\n";
print "please enter the directory whose contents are to be copied to pocketpc...
/books/tmp is the default
";
my $dir=<>;
$dir="/books/tmp\n" if($dir =~ /^$/);
$dir =~ s/\n/\//;
die "will only work on the contents /books or :/\n" if($dir !~ /\/books/ && $dir !~ /:\// );

print "please enter the destination directory 
:/Storage\ Card/My\ Documents/books/ is the default.
";
my $destDir=<>;
$destDir=":/Storage Card/My Documents/books\n" if($destDir =~ /^$/);
$destDir =~ s/\n/\//;
die "will only work on the contents /books or :/\n" if($destDir !~ /\/books/ && $destDir !~ /:\// );


print "$dir\n$destDir\n";
# directory operations
opendir DIR, $dir || die "canst not open the directory $!, lord";
print "reading dir";
my @dirFiles=readdir DIR;
print "@dirFiles\n";
closedir DIR;

my $command;

foreach(@dirFiles)
{
$command= "pcp \"".$dir.$_."\" \"".$destDir.$_."\"\n";
print $command;
system $command;
}


exit;

