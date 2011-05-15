use Test::More tests => 2;

my $module  = "Log::Sigil";
my @methods = qw(
    sigils  count  delimiter  history  splitter
    format  print  say  warn  dump
);
eval "use $module";

my $instance = $module->instance;
isa_ok( $instance, $module );

can_ok( $instance, @methods );

