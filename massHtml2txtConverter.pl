#!/usr/bin/perl -w
use strict;
use warnings;
print "mass html2txt converter in action\n";
print "please enter the directory whose contents are to be converted to *.txt...
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

my $strTxtFile;
foreach(@dirFiles)
{
next if($_ !~/.htm/);
#lynx -dump file.html > file.txt
$strTxtFile=$_;
$strTxtFile =~ s/\.html/\.txt/;
$strTxtFile =~ s/\.htm/\.txt/;

print "lynx -dump \"".$dir.$_."\" >\"$dir".$strTxtFile."\"\n";
system "lynx -dump \"".$dir.$_."\" >\"$dir".$strTxtFile."\"";
}


exit;

