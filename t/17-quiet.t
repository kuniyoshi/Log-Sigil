use Test::More tests => 2;
use Test::Output;
use Log::Sigil;

my $log = Log::Sigil->instance;

stderr_is { $log->warn( "foo" ) } sprintf "### foo at %s line %d.\n", __FILE__, 7;

$log->reset->quiet( 1 );

stderr_is { $log->warn( "foo" ) } q{};

