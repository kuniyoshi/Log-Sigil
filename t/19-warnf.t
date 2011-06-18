use Test::More tests => 1;
use Test::Output;
use Log::Sigil;

my $log = Log::Sigil->instance;

stderr_is {
    $log->warnf( "%d of %d", 2, 3 )
} sprintf "### 2 of 3 at %s line %d.\n", __FILE__, 8;

