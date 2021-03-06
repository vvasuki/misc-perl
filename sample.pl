#! /usr/bin/perl -w
#perl documentation, my style...
# The starategy is to have this as a kind of reference and memory aid... 
# refernces: perldoc perlinfo and other perl tutorials etc...
#whose node names you will find in man perl.
#just use the node name with perldoc. and you have all info.

#there can be other comments too:
=head1 Here There Be Pods!
If the compiler encounters a line
 that begins with an equal sign and a word,
PODs: Embedded Documentation
=cut

#what are line directives? 
#majikal stuff. see man perlsyn.

#for multi-file replacement:
#perl -pi.bak -e "s/Foo/Bar/g" <FileList>
#-p, tells Perl to print each line it reads after applying the alteration. The second option, -e, tells Perl to evaluate the provided substitution regex rather than reading a script from a file.
#-i.bak, which tells Perl to operate on files in-place, rather than concatenating them together into one big output stream. Like the -e option, -i takes one argument, an extension to add to the original file names when making backup copies; for this example I chose .bak. 

use strict;
use warnings;

#praise be to man perldata
#variables in perl include:
#scalars: $var	(a single string)
#arrays:	@var
#hashes:	%var
#file specifiers:	FILE
#Perl also has its own built-in variables whose names don’t
#follow these rules.
#Because variable references always start with ’$’, ’@’, or
# ’%’, the "reserved" words aren’t in fact
#       reserved with respect to variable names.  They are reserve
#d with respect to labels and filehandles.
#Names that start with a digit may contain only more digits
#.  Names that do not start with a letter,
#       underscore, digit or a caret (i.e.  a control character) a
#re limited to one character, e.g.,  $% or $$.

#Perl overloads
#       certain operations based on whether the expected return va
#lue is singular or plural.
#int( <STDIN> )
#       the integer operation provides scalar context for the <> o
#perator, which responds by reading one line
#if, on the other hand, you say
#           sort( <STDIN> )
#       then the sort operation provides list context for <>

#subroutine declaration
#subroutines are named with an initial ’&’, th
#ough this is optional when unambiguous
sub subroutine;

my $strLocal;
#this holds undef now.
#defining the variable with my has made it lexically scoped.
#difeined() and undef() operators may be used here.
$strLocal="localusm";

#various string literal representations
print "$strLocal
	hoo
";
print '$strLocal\n
';
print "%K[%n";


#syntax notes:
#aum. praise be to man perlsyn.
#Every simple statement must be terminated with a semicolon, 
#unless it is the final statement in a block.
#some operators like "eval {}" and
#       "do {}" that look like compound statements, but aren’t.

#The number 0, the strings ’0’ and ’’, the empty list "()",
# and "undef" are all false in a boolean context.

#       Any simple statement may optionally be followed by a SINGL
#E modifier, just before the terminating semi-
#       colon (or block ending).  The possible modifiers are:
#
#           if EXPR
#           unless EXPR
#           while EXPR
#           until EXPR
#           foreach LIST

#The "while" and "until" modifiers have the usual ""while"
# loop" semantics (conditional evaluated
#       first), except when applied to a "do"-BLOCK (or to the de
#precated "do"-SUBROUTINE statement)

my $iTmp=0;
do {$iTmp++} until $iTmp==9;

#arithmatic comparison operators are as in C..
#> < >= !=  etc..
#string comparison operators look like: 
#eq ne lt gt 
#=~	(regular expression matching)

#       The following compound statements may be used to control
#flow:
#
#           if (EXPR) BLOCK
#           if (EXPR) BLOCK else BLOCK
#           if (EXPR) BLOCK elsif (EXPR) BLOCK ... else BLOCK
#           LABEL while (EXPR) BLOCK
#           LABEL while (EXPR) BLOCK continue BLOCK
#           LABEL for (EXPR; EXPR; EXPR) BLOCK
#           LABEL foreach VAR (LIST) BLOCK
#           LABEL foreach VAR (LIST) BLOCK continue BLOCK
#           LABEL BLOCK continue BLOCK
#the curly brackets are required.
#LABEL, if present, consists of an identifier followed
# by a colon.  The LABEL identifies the loop for the loop c
#ontrol statements "next", "last", and "redo".
#If there is a "continue" BLOCK, it is always executed jus
#t before the conditional is about to be evalu-
#       ated again.  Thus it can be used to increment a loop vari
#able, even when the loop has been continued
#       via the "next" statement.
#The "redo" command restarts the loop block without evalua
#ting the conditional again.  The "continue"
#       block, if any, is not executed.
#       The loop control statements don’t work in an "if" or "unless", since they aren’t loops.  You can double
#       the braces to make them such, though.
#
#           if (/pattern/) {{
#               last if /fred/;
#               next if /barney/; # same effect as "last", but doesn’t document as well
#               # do something here
#           }}
#This is caused by the fact that a block by itself acts as a loop that executes once.
#(Note that this is NOT
#       true in "eval{}", "sub{}", or contrary to popular belief "do{}" blocks, which do NOT count as loops.)
#The "foreach" keyword is actually a synonym for the "for" keyword

#The "goto"-LABEL form finds the statement labeled with LABEL 
#and resumes execution there.  
#It may not be used to go into any construct that 
#requires initialization, such as a subroutine 
#or a "foreach" loop.  
#It also can’t be used to go into a construct that is optimized away.  
#It can be used to go almost anywhere else 
#within the dynamic scope, including out of subroutines
#The "goto"-EXPR form expects a label name, whose scope wil
#l be resolved dynamically. 
#goto(("FOO", "BAR", "GLARCH")[$i]);

#       The "goto"-&NAME form is highly magical, and substitutes a
# call to the named subroutine for the cur-
#       rently running subroutine.

#there is no switch block inherantly part of perl.


#arrays
my @mixed   = ("camel", 42, 1.23);
print "$mixed[0]\n"
;
print "$mixed[@mixed-1]\n";	#@mixed in this context refers to the array's length.
print sort(@mixed[1,$#mixed]);	#$#mixed = the last index of the array. 
#sliced array is also demonstrated above.
#inbuilt function sort demonstrated above.
print "\n";


$strLocal="";
$strLocal.=" ".$_ foreach(reverse(@mixed[1 .. $#mixed]));	#another representation of a sliced array
#inbuilt function reverse demonstrated above.
#concatenation operator shown.
print $strLocal . "\n";



#hashes
# %ENV is a special hashtable.
my %fruit_color = ("apple", "red", "banana", "yellow");
%fruit_color = (
		apple  => "red",	#notice that it is apple, not "apple".
		banana => "yellow",
		);
$strLocal="";
#control structures include: if, unless.
if(!$strLocal)
{
print $fruit_color{"apple"} . "\n";
}
print $fruit_color{"apple"} . "\n" unless ($strLocal);

#inbuilt functions for hash keys and values.
my @fruits=keys %fruit_color;
my @colors=values %fruit_color;

#find below a block
{
my $i=0;

#the until loop/ itereation construct.
until($i==@fruits)
{print $colors[$i] . "\n"; $i++;}
}


#reference to hashes of references
my $ref = {
scalar => {
description => "single item",
sigil => '$',
},
array => {
description => "ordered list of items",
sigil => '@',
},
hash => {
description => "key/value pairs",
sigil => '%',
},
};

print "Scalars begin with a $ref->{'scalar'}->{'sigil'}\n";



#file operations
#special file pointers include STDERR

open(OUTFILE, ">/home/guest/vishvas/progs/perl/dummy.txt") or die "Can't open output.txt: $!";
# special variable $! holds the error message.
open(LOGFILE, ">>/home/guest/vishvas/progs/perl/dummy.log")    or die "Can't open logfile: $!";
open FILE,"/home/guest/vishvas/progs/perl/sample.pl"  or die "canst not obey and tear open $!, lord";
#note the use of special variable $_. it saves you from defining another cariable just for this.
print OUTFILE $_ while(<FILE>);
#<FILE> reads a line from a file
print LOGFILE "updated sample.pl in /guest/vishvas, man.";
open FILE,"/home/guest/vishvas/progs/perl/dummy.txt"  or die "canst not obey and tear open $!, lord";
my @lines=<FILE>;

#ahoy! expression matching and replacement.
$lines[0] =~ s/perl/ JAI_PERLA_DI/g;
#.                   a single character
#\s                  a whitespace character (space, tab, newline)
#\S                  non-whitespace character
#\d                  a digit (0-9)
#\D                  a non-digit
#\w                  a word character (a-z, A-Z, 0-9, _)
#\W                  a non-word character
#[aeiou]             matches a single character in the given set
#[^aeiou]            matches a single character outside the given set
#(foo|bar|baz)       matches any of the alternatives specified
#
#^                   start of string
#$                   end of string
#some examples:
#/^$/ and /(\d\s){3}/ 

print $lines[0] if($lines[0] =~ / JAI_PERLA_DI/);
close FILE;
close LOGFILE;
close OUTFILE;



# This loop reads from STDIN, and prints non-blank lines:
#next and last, used to alter normal looping shown.
print "reading from STDIN: type q to quit";
while (<>) {
next if /^$/;
last if /q/;
print;
}
#the above lines implicitly use $_

# a cheap and nasty way to break an email address up into parts
my $email= "prabhu\@mahaswamiyar";
if ($email =~ /([^@])+@(.+)/) 
{
print "Username is $1\n";
print "Hostname is $2\n";
}

# directory operations
opendir DIR, "/home/guest" || die "canst not open the directory $!, lord";
my @dirFiles=readdir DIR;
print "@dirFiles\n";
my $strTmp="";
$strTmp=telldir DIR;
$strTmp.="\n";
#print $strTmp;
closedir DIR;

#for various inbuilt functions, refer to perlfunc.
#interesting functions:
#       Functions for SCALARs or strings
##           "chomp", "chop", "chr", "crypt", "hex", "index", "lc", "lcfirst", "length", "oct",
#           "ord", "pack", "q/STRING/", "qq/STRING/", "reverse", "rindex", "sprintf", "substr",
#           "tr///", "uc", "ucfirst", "y///"

#useful utility.
finddepth (\&wanted, "$sourceFilePath\\com");
sub wanted {
    print "$_";
}

#another subroutine/ function  example:

exit;
