#!/usr/bin/perl

#invocation: 
#ls>inputFile.txt;cat *bib*>>inputFile.txt
#cat inputFile.txt | bibProcessor.pl

my $line;
my $key;
my $keyYear;
my $file;
my @keys;
my @keyYears;
my @files;
my @unmatchedFiles;
while(<>){
    $line = $_;
    if($line =~ /@/ ) {
        #print "$line";
        $key = $line;
        $key =~ s/\s//g;
        $key =~ s/.*{//;
        $key =~ s/[-:].*//;
        $keyYear=$line;
        $keyYear =~ s/\s//g;
        $keyYear =~ s/.*:..//;
        $keyYear =~ s/,.*//;
        #print "$key $keyYear\n";
        $keys[++$#keys]=$key;
        $keyYears[++$#keyYears]=$keyYear;
        my $fileKey = getFileKeysByKey($key, $keyYear);
        $line =~ s/$key:..../$fileKey/;
        print "$line";


    }
    elsif ($line =~ /.pdf/) {
        $line =~ s/\s//g;
        $file = $line;
        $files[++$#files]=$file;
        $unmatchedFiles[++$#unmathcedFiles]=$file;
        #print $file;
    }
    else {
        print $_;
    }
}
print STDERR @unmatchedFiles; 
sub getFileKeysByKey(my $key, my $keyYear) {
    my $fileKey="";
    my $lowerCaseKey =$key;
    $lowerCaseKey =~ tr/[A-Z]/[a-z]/;
    print STDERR "$key $lowerCaseKey $keyYear ";
    my $i=0;
    my $fileKeyIgnoringYr;
    foreach my $file(@files){
        if($file =~ /^$lowerCaseKey[_]/ ) {
#            print "$file\n";
            $fileKeyIgnoringYr .= $file;
            $fileKey .= $file if($file =~/$keyYear/);
            $unmatchedFiles[$i]="";
        }
        $i++;
    }
    if($fileKey =~ //) {
        $fileKey = $fileKeyIgnoringYr;
    }
    $fileKey =~ s/\.pdf//;
    print STDERR "$fileKey\n";
#    print "Exiting...\n";
    return $fileKey;
}

#print "== $#keys ==  @keys\n";
#print "== $#keyYears == @keyYears\n";
#print "== $#files == @files\n";
#print "== $#authors == @authors\n";

