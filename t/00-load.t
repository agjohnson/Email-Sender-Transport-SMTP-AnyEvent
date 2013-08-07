#!perl -T
use 5.010;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Email::Sender::Transport::SMTP::AnyEvent' ) || print "Bail out!\n";
}

diag( "Testing Email::Sender::Transport::SMTP::AnyEvent $Email::Sender::Transport::SMTP::AnyEvent::VERSION, Perl $], $^X" );
