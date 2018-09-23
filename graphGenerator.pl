#! /usr/bin/perl
# Authors: Vishvas Vasuki and Vijay Dewangan

use strict;
use warnings;

use GD;
use GD::Text::Align;

=begin PROGRAM_DOCUMENTATION
Prupose: 
    Suppose that someone runs the following command: 
    $QUALNET_HOME/bin/qualnet sNeighbour.config >dump
    This file generates the mysensor.trace file.
    Using these files, this program generates a 
    node placement/ neighborhood graph.

Invocation:
    ./graphGenerator.pl dumpFileLocation traceFileLocation
    
Assumptions:
    Number of nodes = 1000
    Deployment area = 1000 * 1000
    Z coordinate of a placed node is insignificant.
    
Implementation details:
    In dump, lines beginning with "Partition" contain the coordinates of the nodes.
    So, we extract the coordinates of all the nodes.
    In the resultant graph, we mark these positions.
    
    In mysensor.trace file, the first "PMax" value is determined and multiplied by 1000.
    For lines corresponding to each node, 
    we select neighbors who have reponded to more "Hello"s than this number.
    In the resultant graph, we mark these nieghborhood collections.


    
=end PROGRAM_DOCUMENTATION
=cut

my $iArgs = $#ARGV + 1;
if($iArgs != 2) {
    print "usage: ./graphGenerator.pl dumpFileLocation traceFileLocation \n";
    exit;
}

my $strDumpFile = $ARGV[0];
my $strTraceFile = $ARGV[1];

my @pointsX;
my @pointsY;
my $deploymentAreaWidth = 500;
my $deploymentAreaHeight = 500;

my %nodes;

#print "$strDumpFile $strTraceFile \n";
open FILE_DUMP,"$strDumpFile"  or die "file not found!";
my $line;
my $nodeId;
my @arrCoordinates;
while(<FILE_DUMP>) {
    $line = $_;
    if($line =~ /Partition/) {
        #sample of line processed:
        #Partition 0, Node 998 (181.45, 994.07, 0.00).
        $nodeId = $line;
        $nodeId =~ s/.*Node //;
        $nodeId =~ s/ .*//;
        $nodeId = 0+$nodeId;
        #print "$nodeId \n";
        $line =~ s/.*\(//;
        $line =~ s/\)//;
        @arrCoordinates = split(/,/, $line);
        $nodes{$nodeId}{"x"}= (0+$arrCoordinates[0])/1000*$deploymentAreaWidth;
        $nodes{$nodeId}{"y"}= (0+$arrCoordinates[1])/1000*$deploymentAreaHeight;
        
        #print $nodes{"$nodeId"}{"y"}."\n";
    }
}
close FILE_DUMP;

#print $nodes{100}{"x"}." ".$nodes{100}{"y"}."\n";
#print $nodes{400}{"x"}." ".$nodes{400}{"y"}."\n";

my %lines;
my $pmax;
open FILE_TRACE,"$strTraceFile"  or die "file not found!";
while(<FILE_TRACE>) {
    $line = $_;
    #sample of line processed:
    #The pmax value for this node = 0.833000
	if($line =~/The pmax value for this node = /) {
		$line =~ s/The pmax value for this node = //;
		$line =~ s/\s*//;
		$pmax = 0 + $line;
		$pmax = 1000*$pmax;
		last;
	}
}
close FILE_TRACE;
#print "$pmax\n";

my $iHellosReceived;
my $iNeighbor;
my $ptrArrNeighbors;

open FILE_TRACE,"$strTraceFile"  or die "file not found!";
while(<FILE_TRACE>) {
    $line = $_;
    #sample of line processed:
    #NodeID = 1, Hellos Recieved = 920, From Neighbour = 34, located at DISTANCE = 25.137014
	if($line =~/NodeID = /) {
        $nodeId = $line;
        $nodeId =~ s/.*NodeID = //;
        $nodeId =~ s/,.*//;
        $nodeId = 0+$nodeId;
        #print "$nodeId \n";

        $iHellosReceived = $line;
        $iHellosReceived =~ s/.*Hellos Recieved = //;
        $iHellosReceived =~ s/,.*//;
        $iHellosReceived = 0+$iHellosReceived;
        #print "$iHellosReceived \n";
        if($iHellosReceived >= $pmax) {
            
            $iNeighbor = $line;
            $iNeighbor =~ s/.*From Neighbour = //;
            $iNeighbor =~ s/,.*//;
            $iNeighbor = 0+$iNeighbor;
            #print "$iNeighbor \n";
            if(exists $nodes{$nodeId}{"neighbors"}) {
                $ptrArrNeighbors = $nodes{$nodeId}{"neighbors"};
                push(@$ptrArrNeighbors, $iNeighbor);
                #print "@$ptrArrNeighbors !\n";
            }
            else {
                my @array;
                push(@array, $iNeighbor);
                $nodes{$nodeId}{"neighbors"} = \@array;
                #print "undefined!";
            }
        }
	    
	}
}
close FILE_TRACE;

my $graphFile = "nodePlacementGraph.png";

open(FILE_GRAPH, ">$graphFile") or die "Can't open file: $!";
my $graphOriginX = 50;
my $graphOriginY = 50;
my $pointThickness = 5;
my($image) = new GD::Image($deploymentAreaWidth + 100,$deploymentAreaHeight + 100);
my $black = $image->colorAllocate(0, 0, 0);
my $white = $image->colorAllocate(255, 255, 255);
$image->fill(0, 0, $white);
#$image->arc(50, 25, 98, 48, 0, 360, $black);
$image->rectangle($graphOriginX, $graphOriginY, $graphOriginX+ $deploymentAreaWidth, $graphOriginY+ $deploymentAreaHeight, $black);

my $gdText = GD::Text::Align->new($image,  valign => 'bottom', halign => 'right', color=> $black);
$gdText->set_font(gdMediumBoldFont, 20);
$gdText->set_text(0);
$gdText->draw($graphOriginX,$graphOriginY);
$gdText->set_text(500);
$gdText->draw($graphOriginX + $deploymentAreaWidth/2,$graphOriginY);
$gdText->set_text(500);
$gdText->draw($graphOriginX,$graphOriginY + $deploymentAreaHeight/2);
$gdText->set_text(1000);
$gdText->draw($graphOriginX + $deploymentAreaWidth,$graphOriginY);
$gdText->set_text(1000);
$gdText->draw($graphOriginX,$graphOriginY + $deploymentAreaHeight);

my @nodeIds = keys(%nodes);
foreach my $nodeId(@nodeIds){
    #print "$nodeId ". $nodes{$nodeId}{"x"}."\n";
    $image->filledEllipse($graphOriginX + $nodes{$nodeId}{"x"},$graphOriginY + $nodes{$nodeId}{"y"},$pointThickness,$pointThickness,$black);
    $ptrArrNeighbors = $nodes{$nodeId}{"neighbors"};
    foreach my $neighborNodeId(@$ptrArrNeighbors) {
        #print "$neighborNodeId \n";
        $image->line($graphOriginX + $nodes{$nodeId}{"x"},$graphOriginY + $nodes{$nodeId}{"y"},$graphOriginX + $nodes{$neighborNodeId}{"x"},$graphOriginY + $nodes{$neighborNodeId}{"y"},$black);
    }
}

print FILE_GRAPH $image->png;
close FILE_GRAPH;
