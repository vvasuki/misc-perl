#!/usr/bin/perl

use warnings;
use strict;

use Net::SSH qw(sshopen2);
use Net::FTP;
#usage: perl ./vishvas/progs/perl/progs/syncWithWeb.pl

my $localRoot="/home/vvasuki/vishvas";
my $updateFile=$localRoot."/bangaloreTasks.txt";

#Umass details
my $umassServer="shadow.cs.utexas.edu";
my $umassUname="vvasuki";
my $umassRoot="public_html";

my $_110mbServer="vishvas.110mb.com";
my $_110mbUname="vishvas";
#my $_110mbRoot="/";

my @umassFiles;
my @zendurlFiles;
my @_110mbFiles;

my @umassFilesToDelete;
my @zendurlFilesToDelete;
my @_110mbFilesToDelete;

my $UMASS="umass";
my $_110MB="110mb";
my $EVERYWHERE="everywhere";

my $mode="";

open UPDATE_FILE, $updateFile || die("Could not open file!");

foreach (<UPDATE_FILE>){
    $_ =~ s/\s//;
    chomp $_;
    #print $_;
    if($_ =~ /^#/) {
        $_ =~ s/#//;
        $_ =~ s/://;
        $_ =~ s/update//;
        $mode=$_;
        next;
    }
    next if $mode eq "";
    next if $_ eq "";
    if($mode =~ /$UMASS/){
        if($_ =~ /^rm-/) {
            $_ =~ s/^rm-//;
            push @umassFilesToDelete,$_;
            next;
        }
        push @umassFiles,$_;
        #print "$_ \n";
        next;
    }
    if($mode =~ /$_110MB/){
        if($_ =~ /^rm-/) {
            $_ =~ s/^rm-//;
            push @_110mbFilesToDelete,$_;
            print "removed $_\n";
            #print "$_110mbFilesToDelete[0]\n";
        }
        else {
            push @_110mbFiles,$_;
            print "added $_\n";
        }
        next;
    }
    if($mode =~ /$EVERYWHERE/){
        if($_ =~ /^rm-/) {
            $_ =~ s/^rm-//;
            push @umassFilesToDelete,$_;
            #push @_110mbFilesToDelete,$_;
        }
        else {
            push @umassFiles,$_;
            #push @_110mbFiles,$_;
        }
        next;
    }
    print "$mode\n";
}
close UPDATE_FILE;
#print "$_110mbFilesToDelete[0]\n";
#print "$_110mbFiles[0]\n";
#exit;
#print "$#_110mbFiles|$_110mbFiles[0]|\n";

my $ftp;
my $password = "";

if($#_110mbFiles>=0 || $#_110mbFilesToDelete>=0){
    #print "$#_110mbFiles \n";
    #print "$#_110mbFilesToDelete \n";
    $ftp = Net::FTP->new($_110mbServer, Debug => 0);
    print "connecting to $_110MB\n";
    print "Enter password:";
    $password = <STDIN>;
    chomp $password;
    $ftp->login($_110mbUname,$password) || die "cannot connect";
    print "connected to $_110MB\n";
    $ftp->cwd("/");
    foreach (@_110mbFiles) {
        print "$_\n";
        $ftp->put("$localRoot$_","$_") || die "cannot put $_ \n";
        print "transferred $_ \n";
    }
    foreach (@_110mbFilesToDelete) {
        print "$_\n";
        $ftp->delete("$_") || die "cannot remove $_ \n";
        print "removed $_ \n";
    }
    $ftp->quit;
    print "disconnecting to $_110MB\n";
}

#    print $#umassFiles;
if($#umassFiles>=0||$#umassFilesToDelete>=0){
    #print "@umassFiles \n";
    print "connecting to umass\n";
    foreach (@umassFiles) {
        print "$_\n";
        system "scp $localRoot$_ $umassUname\@$umassServer:$umassRoot$_\n";
        print "transferred $_ \n";
    }
    foreach (@umassFilesToDelete) {
        sshopen2("$umassUname\@$umassServer", *READER, *WRITER, "rm", "$umassRoot$_") || die "ssh: $!";

        print "removed $_\n";
        while (<READER>) {
            chomp();
            print "$_\n";
        }

        close(READER);
        close(WRITER);
    }
    print "disconnecting to umass\n";
}
#print $password;



