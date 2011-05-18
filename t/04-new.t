use Test::More tests => 2;
use Test::Output;
use Log::Sigil;

my $log;

stderr_like(
    sub { $log = Log::Sigil->new },
    qr{Call 'instance' to create a instance of this class insted.},
);

isa_ok( $log, "Log::Sigil" );

