#! /usr/bin/perl
use strict;
use warnings;

#functional simple way
use Audio::Beep;

sub AudioBeep_beep() {
    my $freq = 4333;
    my $milliseconds = 9000;

    beep($freq, $milliseconds);

    #OO more musical way
    use Audio::Beep;

#    my $beeper = Audio::Beep->new();

                # lilypond subset syntax accepted
                # relative notation is the default 
                # (now correctly implemented)
#   my $music = "g' f bes' c8 f d4 c8 f d4 bes c g f2";
                # Pictures at an Exhibition by Modest Mussorgsky

#    $beeper->play( $music );
}

AudioBeep_beep();
