package Log::Sigil;

use strict;
use warnings;
use base "Class::Singleton";
use Class::Accessor "antlers";
use Data::Dumper qw( Dumper );

use constant DEFAULT => {
    sigils    => [ q{#}, qw( - ) ],
    count     => 3,
    delimiter => q{ },
};
use constant DEBUG => 0;

our $VERSION   = "0.04";

has "sigils";
has "count";
has "delimiter";
has "history";

sub _new_instance {
    my $class = shift;
    my %param = @_;
    my $self  = bless \%param, $class;

    foreach my $name ( keys %{ +DEFAULT } ) {
        $self->$name( DEFAULT->{ $name } )
            unless defined $self->$name;
    }

    $self->history( [ ] );

    return $self;
}

sub format {
    my $self  = shift;
    my( $message, $is_suffix_needed )
        = @{ { @_ } }{qw( message is_suffix_needed )};
    my %depth = ( from => 0, history => 0 );
    my $prefix;
    my @suffixes;

    $depth{from}++
        while caller( $depth{from} ) eq __PACKAGE__;
warn "!!! depth: from: $depth{from}" if DEBUG;

    my( $package, $filename, $line ) = caller( $depth{from} );
warn "!!! package: $package"   if DEBUG;
warn "!!! filename: $filename" if DEBUG;
warn "!!! line: $line"         if DEBUG;

    $depth{history}++
        while $depth{history} < @{ $self->history }
            && $self->history->[ $depth{history} ] eq $package;
warn "!!! depth: history: $depth{history}" if DEBUG;

    $depth{history} = $#{ $self->sigils }
        if $depth{history} > $#{ $self->sigils };
warn "!!! depth: history: $depth{history}" if DEBUG;

    $prefix = $self->sigils->[ $depth{history} ];

    unshift @{ $self->history }, $package;

    if ( $is_suffix_needed ) {
        @suffixes  = ( "at", $filename, "line", $line );
warn "!!! suffixes: ", join q{ }, @suffixes if DEBUG;
        $message   = join q{ }, $message, @suffixes;
    }

    return join $self->delimiter, ( $prefix x $self->count ), $message;
}

sub print {
    my $self  = shift;
    my %param = @_;
    my $FH    = delete $param{FH};

    print { $FH } $self->format(
        message          => shift( @{ $param{messages} } ),
        is_suffix_needed => $param{is_suffix_needed},
    ), @{ $param{messages} };
    print { $FH } "\n";

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

sub warn {
    my $self     = shift;
    my @messages = @_;
    my $is_suffix_needed = $messages[-1] !~ m{ [\n] \z}msx;

    return $self->print(
        messages         => \@messages,
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

  $log->warn( "hi there." );                  # -> ### hi there.
  $log->warn( "a prefix will be changeed." ); # -> *** a prefix will be changed.

=head1 DESCRIPTION

Log::Sigil is a message formatter.  Formatting adds a few prefix,
and prefi is a sigil.  This module just add a few prefix to argument
of message, but prefix siginals where are you from.  Changing
sigil by "caller" has most/only things to this module exists.

=head1 METHODS

=over

=item format

returns a formatted string which has a few sigils.

=item print

prints a message via format to file handle.

=item say

likes print, but file handle is specified STDOUT.

=item wran

likes print, but file handle is specified STDERR.

=back

=head1 PROPERTIES

=over

=item deflated_sigils

is a string which sorted by using order sigil.

=item count

specifies how many sigils are added.

=back

=head1 AUTHOR

kuniyoshi kouji E<lt>kuniyoshi@cpan.orgE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
