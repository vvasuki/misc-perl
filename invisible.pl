#!/usr/bin/perl
#usage invisible.pl your_gmail_user_name your_gmail_password

use strict;
use Net::XMPP;
use Term::ReadKey;


my $sttime=time;
print "Username:$ARGV[0]\n";
my $username = "$ARGV[0]";
my $password;

print "Please enter your password: ";
ReadMode('noecho');
$password = ReadLine(0);
ReadMode('restore');


my $resource = 'home';


my $hostname = 'talk.google.com';
my $port = 5222;
my $componentname = 'gmail.com';
my $Contype = 'http';
my $tls = 1;

my %online;
my $Con = new Net::XMPP::Client();
$Con->SetCallBacks(presence=>\&presence_ch);


my $status = $Con->Connect(
hostname => $hostname, port => $port,
componentname => $componentname,
connectiontype => $Contype, tls => $tls);

if (!(defined($status)))
{
print "ERROR: XMPP connection failed.\n";
print " ($!)\n";
exit(0);
}



# Change hostname
my $sid = $Con->{SESSION}->{id};
$Con->{STREAM}->{SIDS}->{$sid}->{hostname} = $componentname;

# Authenticate
my @result = $Con->AuthSend(
username => $username, password => $password,
resource => $resource);

if ($result[0] ne "ok")
{
print "ERROR: Authorization failed: $result[0] - $result[1]\n";
exit(0);
}
else
{
print "Logged in Sucessfull!\nInvisible Users:\n";
}

$Con->PresenceSend(show=>"Available");
sub presence_ch
{
my $p=0;
my $x;
my $presence = pop;
my $from = $presence->GetFrom();

$from =~ s/([a-zA-Z@.]*)\/(.*)/$1/;
if($presence->GetType() eq "unavailable")
{
if (exists $online{$from})
{
delete($online{$from});
}
else
{
$online{$from}=$presence->GetType()."!!" .$presence->GetStatus();
print $from."\n";
}
}

else
{
$online{$from}=$presence->GetType()."!!" .$presence->GetStatus();
}
}


my $currtime;
while(1)
{
$currtime=time;
if($currtime-$sttime>10)
{last;}
my $res=$Con->Process(1);
if(!(defined($res)))
{
last;
}
}
 
