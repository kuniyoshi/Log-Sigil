use Test::More tests => 1;

my $module  = "Log::Sigil";
my @methods = qw(
    instance  _new_instance
    sigils  count  delimiter  history  splitter
    format  print  say  warn  dump
);
eval "use $module";

can_ok( $module, @methods );

