use 5.010;
use strict;
use warnings;

use Module::Build;


my $builder = Module::Build->new(
    module_name => 'Email::Sender::Transport::SMTP::AnyEvent',
    license => 'mit',
    dist_author => q{Anthony Johnson <aj@ohess.org>},
    dist_version_from => 'lib/Email/Sender/Transport/SMTP/AnyEvent.pm',
    release_status => 'stable',
    configure_requires => {
        'Module::Build' => 0,
    },
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'Moo' => 0,
        'AnyEvent' => 0,
        'AnyEvent::SMTP' => 0,
        'Email::Sender' => 0
    },
    add_to_cleanup => [ 'Email-Sender-Transport-SMTP-AnyEvent-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
