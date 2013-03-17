use Test::More tests => 1;

my $module  = "Log::Sigil";
my @methods = qw(
    swarn
    swarn2
);
eval "use $module";

can_ok( $module, @methods );

