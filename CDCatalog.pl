#! /usr/bin/perl -w

use strict;
use warnings;

my $CDContentsFile="/home/guest/vishvas/system/CDCatalog";
my $TmpCDContentsFile="/tmp/currentCDContents";
#file format will be an xml of this format:
#<catalog>
#<CD name="asdf">
#<rawList>...</rawList> 
#<package name="fileName"><description>...</description> </package>
#</CD>
#</catalog>

print "the cd cataloguer program is about to begin\n";
print "please enter the path to the CD (/media/cdrom by default)\n";

my $CDPath = <>;
$CDPath = "/media/cdrom" if $CDPath =~ /^$/;
#print $CDPath."\n";

my $choice="z";
my $CDName, $CDDescription;

while($choice ne "q")
{

	if($choice eq "d")
	{
		print "deleting cd\n";
	}
	else if ($choice eq "u")
	{
		print "updating cd\n";
	}
	else if ($choice eq "a")
	{
		print "adding cd \n";
		system "mount $CDPath";
		
		system "umount $CDPath";

	}
	else if ($choice eq "s")
	{
		print "searching cd\n";
	}
	else if	($choice eq "q")
	{
		print "bye bye\n";
	}

	system "ls -R $CDPath>$TmpCDContentsFile";
	#system "cat $TmpCDContentsFile";
	print "Select catalog operation:
	d Delete CD info
	u Update CD info
	a Add CD info
	s Search
	q Quit 
	";

	$choice = <>;
	chomp($choice);
}

open TMP_CD_CONTENTS_FILE,"$TmpCDContentsFile"  or die "canst not obey and tear open $!, lord";

close TMP_CD_CONTENTS_FILE;

exit;

