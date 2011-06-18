use Test::More tests => 5;
use Test::Output;
use Log::Sigil;

cmp_ok( $Log::Sigil::VERSION, ">", "0.10" );

my $log = Log::Sigil->instance;

package Foo;
sub new  { bless { }, shift }
sub warn { shift; $log->warn( @_ ) }
sub foo  { shift->warn( "foo" ) }
sub bar  { shift->warn( "bar" ) }

package main;
my $foo = Foo->new;
stderr_is { $foo->foo } sprintf "### %s at %s line %d.\n", "foo", __FILE__, 11;
stderr_is { $foo->bar } sprintf "--- %s at %s line %d.\n", "bar", __FILE__, 11;

$log->reset;
$log->bias( 1 );

stderr_is { $foo->foo } sprintf "### %s at %s line %d.\n", "foo", __FILE__, 12;
stderr_is { $foo->bar } sprintf "### %s at %s line %d.\n", "bar", __FILE__, 13;

