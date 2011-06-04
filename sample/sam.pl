#!/usr/bin/perl
use 5.10.0;
use utf8;
use strict;
use warnings;
use open qw( :utf8 :std );
use FindBin;
use lib "$FindBin::Bin/../lib";
use Log::Sigil;

my $log = Log::Sigil->instance;

$log->sigils( q{#}, qw( - + ) );

$, = "T";
#$log->warn( qw( foo bar baz ) );

package Foo;

sub foo {
    $log->warn( "Foo::foo" );
    $log->warn( "Foo::foo" );
    $log->warn( "Foo::foo" );
}

sub bar {
    $log->warn( "Foo::bar" );
    $log->warn( "Foo::bar" );
    $log->warn( "Foo::bar" );
}

package Bar;

sub foo {
    $log->warn( "Bar::foo" );
    $log->warn( "Bar::foo" );
    $log->warn( "Bar::foo" );
}

sub bar {
    $log->warn( "Bar::bar" );
    $log->warn( "Bar::bar" );
    $log->warn( "Bar::bar" );
}

package main;

$log->warn( "foo" );
$log->warn( "foo" );

local $, = "TTT";

Foo::foo();
Bar::foo();
Foo::bar();
Bar::foo();
Bar::bar();

$log->warn( "foo" );
$log->warn( "foo" );

$log->dump( [] );

