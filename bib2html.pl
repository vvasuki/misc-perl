#! /usr/bin/perl -w
use strict;
use warnings;

my @lines;
while(<>) {
    $lines[++$#lines] = $_;
}

#my $numLines = #@lines;
my $line;
my %bibEntry;
my $strSource;
my $pdfPath="../../media/papers/synchronization/";
for (my $count = 0; $count < @lines; $count++) {
    $line = $lines[$count];
    #print $line;
    if($line=~/@/){
        #    print "asdfasdfasdfffffffffffffffffffffffffffffffff \n"
        #    print %bibEntry;
        #    print "\n";
#            print "$bibEntry{'author'} \n";
#            print "$bibEntry{'title'} \n";
            $strSource = '';
            $strSource .= $bibEntry{'journal'} if exists $bibEntry{'journal' };
            $strSource .= $bibEntry{'booktitle'} if exists $bibEntry{'booktitle' };
            $strSource .= $bibEntry{'type'} if exists $bibEntry{'type' };
#            print "$strSource \n";
#            print "$bibEntry{'url'} \n";
        
        #final target:
        #<tr><td><br />S.V.R. Anand<br /></td><td>A short note on<br />VigilNet and <br />&quot;A Line in the Sand&quot;<br /></td><td><a href="http://ece.iisc.ernet.in/sensors/media/papers/surveillance-sensor-network-projects.pdf">download</a><br /></td></tr>
            my $htmlCode = "<tr><td>" . $bibEntry{'author'} . "</td><td>". $bibEntry{'title'}.'</td><td>'.$strSource.'</td><td><a href="'.$bibEntry{'url'}.'">download</a></td></tr>'."\n";
            $htmlCode =~ s/download/no file!/ if($htmlCode =~ /\/\.pdf/);
            print "$htmlCode";
        
            %bibEntry = ();
            my $bibEntryPropValue = $line;
            $bibEntryPropValue =~ s/.*{//g;
            $bibEntryPropValue =~ s/,//g;
            $bibEntryPropValue =~ s/\s*$//g;
            $bibEntryPropValue =~ s/^\s*//g;
            $bibEntry{"url"} = $pdfPath.$bibEntryPropValue . ".pdf";
    }
    my $bibEntryProp = $line;
    $bibEntryProp =~ s/=.*//g;
    $bibEntryProp =~ s/\s*$//g;
    $bibEntryProp =~ s/^\s*//g;
    $bibEntryProp =~ tr/[A-Z]/[a-z]/;

    my $bibEntryPropValue = $line;
    $bibEntryPropValue =~ s/.*=//g;
    $bibEntryPropValue =~ s/\s*$//g;
    $bibEntryPropValue =~ s/^\s*//g;
    $bibEntryPropValue =~ s/[{}]//g;
    $bibEntryPropValue =~ s/,//g;

    $bibEntry{"$bibEntryProp"} = $bibEntryPropValue;
}
    my $htmlCode = "<tr><td>" . $bibEntry{'author'} . "</td><td>". $bibEntry{'title'}.'</td><td>'.$strSource.'</td><td><a href="'.$bibEntry{'url'}.'">download</a></td></tr>'."\n";
    print "$htmlCode";






