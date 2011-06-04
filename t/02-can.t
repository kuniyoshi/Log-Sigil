use Test::More tests => 1;

my $module  = "Log::Sigil";
my @methods = qw(
    instance  _new_instance  new
    sigils  repeats  delimiter  bias  history  splitter
    reset  format  print  say  warn  dump
);
eval "use $module";

can_ok( $module, @methods );

