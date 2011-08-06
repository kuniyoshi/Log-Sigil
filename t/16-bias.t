use Test::More tests => 4;
use Test::Output;
use Log::Sigil;

my $log = Log::Sigil->instance;

package Foo;
sub new  { bless { }, shift }
sub warn { shift; $log->warn( @_ ) }
sub foo  { shift->warn( "foo" ) }
sub bar  { shift->warn( "bar" ) }

package main;
my $foo = Foo->new;
stderr_is { $foo->foo } sprintf "### %s at %s line %d.\n", "foo", __FILE__, 9;
stderr_is { $foo->bar } sprintf "--- %s at %s line %d.\n", "bar", __FILE__, 9;

$log->reset;
$log->bias( 1 );

stderr_is { $foo->foo } sprintf "### %s at %s line %d.\n", "foo", __FILE__, 10;
stderr_is { $foo->bar } sprintf "### %s at %s line %d.\n", "bar", __FILE__, 11;

