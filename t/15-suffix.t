use Test::More tests => 1;
use Test::Output;
use Log::Sigil;

my $log = Log::Sigil->instance;

sub sigil_warn {
    $log->warn( "foo" );
}

stderr_is { sigil_warn( ) } sprintf "### foo at %s line %d.\n", __FILE__, 8;

