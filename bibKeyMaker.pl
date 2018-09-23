#! /usr/bin/perl -w
use strict;
use warnings;

sub getLastName(){
    my($name) = @_;

    if($name =~ /,/){
        $name =~ s/,.*//;
        $name =~ s/\s*//;
    }
    else {
        $name =~ s/\s+/ /;
        $name =~ s/.* //;
    }
    $name =~ tr/[A-Z]/[a-z]/;
    return $name;
}

sub getAuthorListKey(){
    my($authorList) = @_;
    #print "$authorList \n";
    my @authors;
    @authors = split(/ and /, $authorList);
#    print "@authors \n";
    my $author;
    my $arrayCount = 0;
    foreach $author (@authors) {
        $authors[$arrayCount] = &getLastName($author);
        $arrayCount++;
    }
    if($#authors>1) {
        $#authors=1;
        $authors[1]="etal";
    }

    my $authorListKey = join('-',@authors);
    return $authorListKey;

}


sub getKeywordsString(){
    my($phrase) = @_;
    my $maximumKeywords = 4;
    $phrase =~ tr/[A-Z]/[a-z]/;
    my @words = split(/ /,$phrase);
    my @keywords;
    my $commonWordsList = "is a the of for on at analysis survey and research";
    foreach my $word (@words) {
        next if($commonWordsList =~ /$word/);
        $keywords[++$#keywords]=$word;
    }
#    print "$phrase: @keywords\n\n";
    $#keywords = $maximumKeywords-1 if($#keywords>$maximumKeywords-1);
    my $keyWordsString = join('-',@keywords);
    return $keyWordsString;

}

sub printKey(){
    my(%bibEntry) = @_;
    my $yearKey = $bibEntry{"year"};
    my $key;
    $yearKey =~ s/^..//;
    $key = &getAuthorListKey($bibEntry{"author"});
    $key .= $yearKey;
    $key .= '-'.&getKeywordsString($bibEntry{"title"});
    print "$key\n";
    #print %bibEntry;
}

my @lines;
while(<>) {
    $lines[++$#lines] = $_;
}

#my $numLines = #@lines;
my $line;
my %bibEntry;
my @authors;
my $pdfPath="../../media/papers/synchronization/";
my $key;
for (my $count = 0; $count < @lines; $count++) {
    $line = $lines[$count];
    #print $line;
    if($line=~/@/){
        #final target:
        if($count != 0){
            &printKey(%bibEntry);
        }
        %bibEntry = ();
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
    $bibEntryPropValue =~ s/[{}"]//g;
    $bibEntryPropValue =~ s/,$//;

    $bibEntry{"$bibEntryProp"} = $bibEntryPropValue;
}

&printKey(%bibEntry);
#&getAuthorList($bibEntry{"author"});




