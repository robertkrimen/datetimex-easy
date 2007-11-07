package DateTimeX::Easy;

use warnings;
use strict;

=head1 NAME

DateTimeX::Easy - Quickly and easily create a DateTimeX object (by parsing almost anything)

=head1 VERSION

Version 0.03

=cut

our $VERSION = '0.03';

=head1 SYNOPSIS

    # Make DateTimeX object for "now":
    my $dt = DateTimeX::Easy->new("today");

    # Same thing:
    my $dt = DateTimeX::Easy->new("now");

    # Uses Date::Manip's coolness:
    my $dt = DateTimeX::Easy->new("last monday");

    # ... but in 1969:
    my $dt = DateTimeX::Easy->new("last monday", year => 1969);

    # ... at the 100th nanosecond:
    my $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100);

    # ... in EST: (This will NOT do a timezone conversion)
    my $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Eastern");
    ok($dt);

    # This WILL do a proper timezone conversion:
    my $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Pacific");
    $dt->set_time_zone("US/Eastern");

=head1 DESCRIPTION

DateTimeX::Easy makes DateTimeX object creation quick and easy. It uses Date::Manip::ParseDate to parse almost anything you can throw at it.

=head1 METHODS

=head2 DateTimeX::Easy->new( ... )

=head2 DateTimeX::Easy->parse( ... )

Parse the given date/time specification using Date::Manip::ParseDate and use the result to create a DateTimeX object. Returns a L<DateTimeX> object.
Any timezone information from Date::Manip is ignored. To specify an explicit timezone, pass a timezone parameter through.

You can pass the following in:

    parse       # The string for DateManip to parse via ParseDate
    year        # A year to override the result of parsing
    month       # A month to override the result of parsing
    day         # A day to override the result of parsing
    hour        # A hour to override the result of parsing
    minute      # A minute to override the result of parsing
    second      # A second to override the result of parsing
    truncate    # A truncation parameter (e.g. year, day, month, week, etc.)
    timezone    # A timezone (e.g. US/Pacific, UTC, etc.)
                # Either time_zone or timezone will work, but "time_zone" has precedence

    ... and anything else that you want to pass to the DateTime->new constructor

If C<truncate> is specificied, then DateTime->truncate will be run after object creation.

Furthermore, you can simply pass the value for "parse" as the first positional argument of the DateTimeX::Easy call, e.g.:

    # This:
    DateTimeX::Easy->new("today", year => 2008, truncate => "hour");

    # ...is the same as this:
    DateTimeX::Easy->new(parse => "today", year => 2008, truncate => "hour");

=head1 EXPORT

=head2 parse( ... )

=head2 parse_date( ... )

=head2 parse_datetime( ... )

=head2 date( ... )

=head2 datetime( ... )

=head2 new_date( ... )

=head2 new_datetime( ... )

Same syntax as above. See above for more information.

=head1 MOTIVATION

Although I really like using DateTimeX for date/time handling, I was often frustrated by its inability to parse even the simplest of date/time strings.
There does exist a wide variety of DateTimeX::Format::* modules, but they all have different interfaces and different capabilities.
Coming from a Date::Manip background, I wanted something that gave me the power of ParseDate while still returning a DateTimeX object.
Most importantly, I wanted explicit control of the timezone setting at every step of the way. DateTimeX::Easy is the result.

=head1 SEE ALSO

L<DateTimeX>, L<Date::Manip>

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-datetime-easy at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DateTimeX-Easy>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DateTimeX::Easy


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DateTimeX-Easy>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DateTimeX-Easy>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DateTimeX-Easy>

=item * Search CPAN

L<http://search.cpan.org/dist/DateTimeX-Easy>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2007 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

use base qw/Exporter/;
our @EXPORT_OK = qw/datetime parse parse_datetime parse_date new_datetime new_date date/;

use Date::Manip qw/ParseDate UnixDate/;
use DateTime;
use Scalar::Util qw/blessed/;

sub new {
    shift if $_[0] && $_[0] eq __PACKAGE__;

    my $parse;
    $parse = shift if @_ % 2;

    my %in = @_;
    $parse = delete $in{parse} if exists $in{parse};
    my $truncate = delete $in{truncate};

    my %DateTime;
    if ($parse) {
        if (blessed $parse && $parse->isa("DateTime")) {
            $DateTime{$_} = $parse->$_ for qw/year month day hour minute second nanosecond time_zone/;
        }
        else {
            return unless $parse = UnixDate($parse, '%Y %m %d %H %M %S');
            @DateTime{qw/year month day hour minute second/} = split m/\s+/, $parse; 
        }
    }
    $DateTime{time_zone} = delete $in{timezone} if exists $in{timezone};
    @DateTime{keys %in} = values %in;
    return unless my $dt = DateTime->new(%DateTime);
    if ($truncate) {
        $truncate = $truncate->[1] if ref $truncate eq "ARRAY";
        $truncate = (values %$truncate)[0] if ref $truncate eq "HASH";
        $dt->truncate(to => $truncate);
    }

    return $dt;
}
*parse = \&new;
*parse_date = \&new;
*parse_datetime = \&new;
*date = \&new;
*datetime = \&new;
*new_date = \&new;
*new_datetime = \&new;

1; # End of DateTimeX::Easy
