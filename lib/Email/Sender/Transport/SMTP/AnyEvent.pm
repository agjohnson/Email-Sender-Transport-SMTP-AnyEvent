package Email::Sender::Transport::SMTP::AnyEvent;

use 5.010;
use strict;
use warnings;

use Moo;
use MooX::Types::MooseLike::Base qw(Bool Int Str);

use Email::Sender::Success;
use Email::Sender::Success::Partial;
use Email::Sender::Failure;
use Email::Sender::Failure::Multi;
use Email::Sender::Util;

use AnyEvent;
use AnyEvent::SMTP::Client;

with 'Email::Sender::Transport';

=head1 NAME

Email::Sender::Transport::SMTP::AnyEvent - AnyEvent sender transport

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

# Properties
has host => (is => 'ro', isa => Str, default => sub { 'localhost' });
has port => (is => 'ro', isa => Int, lazy => 1, default => sub { 25 });
has helo => (is => 'ro', isa => Str);
has timeout => (is => 'ro', isa => Int, default => sub { 120 });


sub send_email {
    my ($self, $email, $args) = @_;

    Email::Sender::Failure->throw("no valid addresses in recipient list")
      unless my @to = grep { defined and length } @{ $args->{to} };

    my $cv = AnyEvent->condvar;
    AnyEvent::SMTP::Client::sendmail(
        host => $self->host,
        port => $self->port,
        helo => $self->helo,
        timeout => $self->timeout,
        from => $email->get_header('from'),
        to => \@to,
        data => $email->as_string,
        cb => sub {
            my ($pass, $fail) = @_;
            if (defined $pass) {
                $cv->send(Email::Sender::Success->new);
            }
            elsif (defined $fail) {
                $cv->send(Email::Sender::Failure->new($fail));
            }
            else {
                $cv->send(Email::Sender::Failure->new('Unknown'));
            }
        }
    );
    return $cv;
}


no Moo;

=head1 AUTHOR

Anthony Johnson, C<< <aj at ohess.org> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2013 Anthony Johnson.

This program is distributed under the MIT (X11) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.


=cut

1;
