use Test::More tests => 2;
use Test::Output;
use Log::Sigil;

my $log;

stderr_like(
    sub { $log = Log::Sigil->new },
    qr{Call 'instance' insted of new.},
);

isa_ok( $log, "Log::Sigil" );

