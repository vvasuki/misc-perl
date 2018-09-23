#! /usr/bin/perl -w
#commands to use with this:
#giftd -v 2>tmp
#grep -P [0-9]+[.][0-9]+[.][0-9]+[.][0-9] tmp -o|sort>tmp1  
use strict;
use warnings;

system "grep -P [0-9]+[.][0-9]+[.][0-9]+[.][0-9] /home/guest/tmp -o|sort -u>/home/guest/tmp1";
my $noFtpList;

open HIST_FILE,"/home/guest/tmp2"  or die "canst not obey and tear open $!, lord";
$noFtpList=<HIST_FILE>;
print "$noFtpList\n";
close HIST_FILE;


open FILE,"/home/guest/tmp1"  or die "canst not obey and tear open $!, lord";
open HIST_FILE,">/home/guest/tmp2"  or die "canst not obey and tear open $!, lord";

while(<FILE>)
{
#print $_;
if($_ =~ /0[.].+/)
{
	print "skipping $_";
}
$_=~s/\n//;
if(system("nmap $_ -p 21|grep \"21/tcp open\""))
{
print "$_ has no ftp\n";
print HIST_FILE,"$_\n";
}
else
{
print "********* $_ has ftp ***********\n\b\b\b";
}

}
close FILE;
close HIST_FILE;
exit 0;

