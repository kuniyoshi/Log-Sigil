use Test::More tests => 1;

my $module  = "Log::Sigil";
my @methods = qw(
    instance  _new_instance  new
    sigils  repeats  delimiter  bias  quiet  history  splitter
    reset  format  print  say  sayf  warn  warnf  dump
);
eval "use $module";

can_ok( $module, @methods );

