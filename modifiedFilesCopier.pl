# perl "C:\Documents and Settings\vvasuki\My Documents\vishvas\progs\perl\progs\modifiedFilesCopier.pl"
use strict;
use warnings;
print "the copier  of modified files to vemoram thing now runs\n";
my $basePath="C:\\Documents and Settings\\vvasuki\\My Documents\\ms\\javaRdp\\rdpclient on vemoram-lptp\\";
my $destPath="\\\\vemoram-lptp\\rdpclient\\";
my $modifiedFileList="stuffModifiedByVishvas.txt";
copyFile($modifiedFileList  );
open FILE,$basePath.$modifiedFileList  or die "canst not obey and tear open $!, lord";
my @lines=<FILE>;
my $count;
for($count=0;$count<@lines;$count++)
{
$lines[$count]=~ s/\n//g;
$lines[$count]=~ s/\//\\/g;
#$lines[$count]=~ s/\\/\\\\/g;
copyFile($lines[$count]);
}

close FILE;
print "\njob done.\n";
<>;
exit;

sub copyFile()
{
my $fileName=$_[0];
my $command;
my $srcFile;
my $destFile;
$srcFile='"'.$basePath.$fileName.'"';
$destFile='"'.$destPath.$fileName.'"';
$command="copy $srcFile $destFile";
print $command."\n";
system $command;

}