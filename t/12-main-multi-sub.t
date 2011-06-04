use Test::More;
use Log::Sigil;
use IO::Scalar;

my $log = Log::Sigil->instance;
my $FH  = IO::Scalar->new( \my $output );

sub foo {
    $log->print( messages => ["foo"], FH => $FH );
    $log->print( messages => ["bar"], FH => $FH );
    $log->print( messages => ["baz"], FH => $FH );
}

sub bar {
    $log->print( messages => ["foo"], FH => $FH );
    $log->print( messages => ["bar"], FH => $FH );
    $log->print( messages => ["baz"], FH => $FH );
}

foo( );
bar( );

my @logs = split m{\n}, $output;

my @wish_list = (
    "### foo", "--- bar", "--- baz",
    "### foo", "--- bar", "--- baz",
);

plan tests => 1 + @wish_list;

# i need information more than id_deeply.

is( @logs, @wish_list );

foreach my $index ( 1 .. @logs ) {
    is( $logs[ $index ], $wish_list[ $index ] );
}



