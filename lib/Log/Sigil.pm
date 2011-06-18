package Log::Sigil;
use strict;
use warnings;
use base "Class::Singleton";
use Carp qw( carp croak );
use Readonly;
use Class::Accessor "antlers";
use Data::Dumper qw( Dumper );

use constant DEBUG => 0;

Readonly my %DEFAULT => {
    sigils    => [ q{#}, qw( - ) ],
    repeats   => 3,
    delimiter => q{ },
};

our $VERSION = "0.11";

has "sigils";
has "repeats";
has "delimiter";
has "bias";
has "quiet";
has "history";
has "splitter";

sub new {
    my $class = shift;
    carp "Call 'instance' insted of new.";
    return $class->instance( @_ );
}

sub _new_instance {
    my $class = shift;
    my %param = @_;
    my $self  = bless \%param, $class;

    foreach my $name ( keys %DEFAULT ) {
        $self->$name( $DEFAULT{ $name } )
            unless defined $self->$name;
    }

    $self->reset;

    return $self;
}

sub reset {
    my $self = shift;
    $self->history( [ ] );
    return $self;
}

sub format {
    my $self  = shift;
    my( $message, $is_suffix_needed )
        = @{ { @_ } }{qw( message is_suffix_needed )};
    my %depth = ( from => 0, history => 0 );
    my %context;
    my $prefix;
    my @suffixes;
    my $count = abs( $self->bias || 0 );

    while ( ! $context{name} ) {
        @context{qw( package filename line subroutine )} = caller ++$depth{from};

        last
            unless $context{package};

        if ( $context{package} ne __PACKAGE__ ) {
            if ( $context{subroutine} ) {
                next
                    if 0 == index $context{subroutine}, __PACKAGE__;

                next
                    if $count-- > 0;

                $context{name} = $context{subroutine};
                @context{qw( filename line )} = ( caller( $depth{from} - 1 ) )[1, 2];
            }
            else {
                $context{name} = $context{package};
            }
        }
    }

    $context{name} ||= q{};

warn "!!! depth: from: $depth{from}"        if DEBUG;
warn "!!! package: $context{package}"       if DEBUG;
warn "!!! filename: $context{filename}"     if DEBUG;
warn "!!! line: $context{line}"             if DEBUG;
warn "!!! subroutine: $context{subroutine}" if DEBUG;

    $depth{history}++
        while $depth{history} < @{ $self->history }
            && ${ $self->history }[ $depth{history} ] eq $context{name};
warn "!!! depth: history: $depth{history}" if DEBUG;

    # Just a safety for the array length.
    $depth{history} = $#{ $self->sigils }
        if $depth{history} > $#{ $self->sigils };
warn "!!! depth: history: $depth{history}" if DEBUG;

    $prefix = $self->sigils->[ $depth{history} ];

    unshift @{ $self->history }, $context{name};
warn "!!! histroy: ", join " - ", @{ $self->history } if DEBUG;

    if ( $context{filename} && $context{line} && $is_suffix_needed ) {
        $message = sprintf(
            "%s at %s line %d.",
            $message,
            @context{qw( filename line )},
        );
    }

    return join $self->delimiter, ( $prefix x $self->repeats ), $message;
}

sub print {
    my $self  = shift;
    my %param = @_;
    my $FH    = delete $param{FH};

    return $self
        if $self->quiet;

    $self->splitter( defined $, ? $, : q{} );

    local $,;

    print { $FH } $self->format(
        message          => join( $self->splitter, @{ $param{messages} } ),
        is_suffix_needed => $param{is_suffix_needed},
    ), "\n";

    return $self;
}

sub say {
    my $self     = shift;
    my @messages = @_;

    return $self->print(
        messages => \@messages,
        FH       => *STDOUT,
    );
}

sub sayf {
    my $self     = shift;
    my $format   = shift;
    my @messages = @_;

    return $self->print(
        messages => [ sprintf( $format, @messages ) ],
        FH       => *STDOUT,
    );
}

sub warn {
    my $self             = shift;
    my @messages         = @_;
    my $is_suffix_needed = $messages[-1] !~ m{ [\n] \z}msx;

    return $self->print(
        messages         => \@messages,
        FH               => *STDERR,
        is_suffix_needed => $is_suffix_needed,
    );
}

sub warnf {
    my $self             = shift;
    my $format           = shift;
    my @messages         = @_;
    my $is_suffix_needed = $messages[0] !~ m{ [\n] \z}msx;

    return $self->print(
        messages         => [ sprintf( $format, @messages ) ],
        FH               => *STDERR,
        is_suffix_needed => $is_suffix_needed,
    );
}

sub dump {
    my $self     = shift;
    my @messages = @_;

    local $Data::Dumper::Terse = 1;

    return $self->print(
        messages         => [ map { Dumper( $_ ) } @messages ],
        FH               => *STDERR,
        is_suffix_needed => 1,
    );
}

1;
__END__

=head1 NAME

Log::Sigil - show warnings with sigil prefix

=head1 SYNOPSIS

  use Log::Sigil;
  my $log = Log::Sigil->new;

  $log->quiet( 1 ) if ! DEBUG;

  $log->warn( "hi there." );                  # -> ### hi there.
  $log->warn( "a prefix will be changeed." ); # -> --- a prefix will be changed.

  package Foo;
  sub new  { $log->bias( 1 ); bless { }, shift }
  sub warn { $log->warn( @_ ) }

  package main;
  Foo->new->warn( "foo" );

=head1 DESCRIPTION

Log::Sigil is a message formatter.  Formatting adds a few prefix,
and prefi is a sigil.  This module just add a few prefix to argument
of message, but prefix siginals where are you from.  Changing
sigil by "caller" has most/only things to this module exists.

*Note: this can [not] add a suffix of filename and line in the file
when called from [no] sub.  This depends on 'caller' function.

=head1 METHODS

=over

=item say

Likes say message with sigil prefix.

=item sayf

Likes say, but first argument will be format of the sprintf.

=item wran

Likes say, but file handle is specified STDERR.

=item warnf

Likes warn, but first argument will be format of the sprintf.

=item dump

Likes warn, but args are changed by Data::Dumper::Dumper.

=back

=head1 PROPERTIES

=over

=item sigils

Is a array-ref which sorted by using order sigil.

=item repeats

Specifies how many sigil is repeated.

=item delimiter

Will be placed between sigil and log message.

=item bias

Controls changing of sigil.  bias for the depth of caller.

=item quiet

Tells Log::Sigil to no output required.

Please remove Log::Sigil from code in production.
Set true this when you felt Log::Sigil is riot.

=back

=head1 AUTHOR

kuniyoshi kouji E<lt>kuniyoshi@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

