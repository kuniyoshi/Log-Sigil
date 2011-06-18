use Test::More tests => 1;
use Test::Output;
use Log::Sigil;

my $log = Log::Sigil->instance;

stdout_is {
    $log->sayf( "%d of %d", 2, 3 )
} "### 2 of 3\n";

