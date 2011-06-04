use Test::More tests => 3;
use Log::Sigil;

my $log = Log::Sigil->instance;
is_deeply( $log->history, [ ] );

push @{ $log->history }, "foo";
is_deeply( $log->history, [ qw( foo ) ] );

$log->reset;
is_deeply( $log->history, [ ] );

