use Test::More;
use Log::Sigil;

my $log = Log::Sigil->instance;
open my $FH, ">", \my $output
    or die $!;

package Foo;
sub bar {
    $log->print( messages => ["foo"], FH => $FH );
    $log->print( messages => ["bar"], FH => $FH );
    $log->print( messages => ["baz"], FH => $FH );
}

sub baz {
    $log->print( messages => ["foo"], FH => $FH );
    $log->print( messages => ["bar"], FH => $FH );
    $log->print( messages => ["baz"], FH => $FH );
}

package main;
Foo->bar;
Foo->baz;

close $FH
    or die $!;

my @logs = split m{\n}, $output;

my @wish_list = (
    "### foo", "--- bar", "--- baz",
    "### foo", "--- bar", "--- baz",
);

plan tests => 1 + @wish_list;

# i need information more than id_deeply.

is( @logs, @wish_list );

foreach my $index ( 1 .. @logs ) {
    is( $logs[ $index - 1 ], $wish_list[ $index - 1 ] );
}




