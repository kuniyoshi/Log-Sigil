use Test::More tests => 2;

my $module  = "Log::Sigil";
my @methods = qw(
    instance  _new_instance  new
    sigils  repeats  delimiter  bias  history  splitter
    reset  format  print  say  sayf  warn  warnf  dump
);
eval "use $module";

my $instance = $module->instance;
isa_ok( $instance, $module );

can_ok( $instance, @methods );

