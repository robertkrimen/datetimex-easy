package DateTimeX::Easy;

use warnings;
use strict;

=head1 NAME

DateTimeX::Easy - Use DT::F::Flexible and DT::F::Natural for quick and easy DateTime creation

=head1 VERSION

Version 0.060

=cut

our $VERSION = '0.060';

=head1 SYNOPSIS

    # Make DateTimeX object for "now":
    my $dt = DateTimeX::Easy->new("today");

    # Same thing:
    my $dt = DateTimeX::Easy->new("now");

    # Uses ::F::Natural's coolness (similar in capability to Date::Manip)
    my $dt = DateTimeX::Easy->new("last monday");

    # ... but in 1969:
    my $dt = DateTimeX::Easy->new("last monday", year => 1969);

    # ... at the 100th nanosecond:
    my $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100);

    # ... in US/Eastern: (This will NOT do a timezone conversion)
    my $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Eastern");

    # This WILL do a proper timezone conversion:
    my $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Pacific");
    $dt->set_time_zone("US/Eastern");

=head1 DESCRIPTION

DateTimeX::Easy makes DateTime object creation quick and easy. It uses DateTime::Format::Flexible and DateTime::Format::Natural to do the
bulk of the parsing, with some custom tweaks to smooth out the rough edges (mainly concerning timezone detection).

=head1 METHODS

=head2 DateTimeX::Easy->new( ... )

=head2 DateTimeX::Easy->parse( ... )

=head2 DateTimeX::Easy->parse_date( ... )

=head2 DateTimeX::Easy->parse_datetime( ... )

=head2 DateTimeX::Easy->date( ... )

=head2 DateTimeX::Easy->datetime( ... )

=head2 DateTimeX::Easy->new_date( ... )

=head2 DateTimeX::Easy->new_datetime( ... )

Parse the given date/time specification using ::F::Flexible or ::F::Natural and use the result to create a L<DateTime> object. Returns a L<DateTime> object.

You can pass the following in:

    parse       # The string or DateTime object to parse.
    year        # A year to override the result of parsing
    month       # A month to override the result of parsing
    day         # A day to override the result of parsing
    hour        # A hour to override the result of parsing
    minute      # A minute to override the result of parsing
    second      # A second to override the result of parsing
    truncate    # A truncation parameter (e.g. year, day, month, week, etc.)

    time_zone   # - Can be:
                # * A timezone (e.g. US/Pacific, UTC, etc.)
                # * A DateTime special timezone (e.g. floating, local)
                # * A question mark ('?'), which means to use the timezone parsed from the end of the string, e.g. "... GMT" or "... US/Eastern"
                #
                # - If neither "timezone" nor "time_zone" is set, then we'll default to using "?", and then "floating"
                # - If a DateTime object was passed in, then the object's timezone will be used unless overridden.
                # - Either "time_zone" or "timezone" will work, but "time_zone" has precedence
                # - WARNING: No timezone conversion takes place (unless "convert => 1" is set), the timezone is essentially appended to the datetime given.
                # - See below for examples!

    convert     # Set this flag to 1 if you want to actually perform the conversion be between the parsed timezone and the given timezone
                # Optionally, set it to the timezone you want to convert to. In this case, "time_zone" is the original "old" timezone
                # and "convert" is the "new" timezone. Furthermore, in this case, "time_zone" will become "local" if it's "floating".

    ... and anything else that you want to pass to the DateTime->new constructor

If C<truncate> is specificied, then DateTime->truncate will be run after object creation.

Furthermore, you can simply pass the value for "parse" as the first positional argument of the DateTimeX::Easy call, e.g.:

    # This:
    DateTimeX::Easy->new("today", year => 2008, truncate => "hour");

    # ... is the same as this:
    DateTimeX::Easy->new(parse => "today", year => 2008, truncate => "hour");

Timezone processing can be a little complicated.  Here are some examples:

    DateTimeX::Easy->parse("today"); # Will use a floating timezone

    DateTimeX::Easy->parse("2007-07-01 10:32:10"); # Will ALSO use a floating timezone

    DateTimeX::Easy->parse("2007-07-01 10:32:10 US/Eastern"); # Will use US/Eastern as a timezone

    DateTimeX::Easy->parse("2007-07-01 10:32:10 US/Eastern", time_zone => "?"); # Will again use US/Eastern as the timezone

    DateTimeX::Easy->parse("2007-07-01 10:32:10", time_zone => "?"); # Will use the floating timezone

    DateTimeX::Easy->parse("2007-07-01 10:32:10 UTC", convert => "US/Pacific"); # Will convert from UTC to US/Pacific

    DateTimeX::Easy->parse("2007-07-01 10:32:10", convert => "US/Pacific"); # Will convert from the local timezone to US/Pacific

    my $dt = DateTime->now->set_time_zone("US/Eastern");
    DateTimeX::Easy->parse($dt); # Will use US/Eastern as the timezone

    DateTimeX::Easy->parse($dt, time_zone => "floating"); # Will use a floating timezone

    DateTimeX::Easy->parse($dt, time_zone => "US/Pacific"); # Will use US/Pacific as the timezone with NO conversion
                                                            # For example, "22:00 US/Eastern" will become "22:00 PST8PDT" 

    DateTimeX::Easy->parse($dt)->set_time_zone("US/Pacific"); # Will use US/Pacific as the timezone WITH conversion
                                                              # For example, "22:00 US/Eastern" will become "19:00 PST8PDT" 

    DateTimeX::Easy->parse($dt, time_zone => "US/Pacific", convert => 1); # Will ALSO use US/Pacific as the timezone WITH conversion

    DateTimeX::Easy->parse($dt, time_zone => "US/Pacific", convert => "UTC"); # Will convert FROM US/Pacific TO UTC

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

L<DateTime>, L<DateTime::Format::Natural>, L<DateTime::Format::Flexible>, L<Date::Manip>

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

use DateTime;
use DateTime::Format::Natural;
use DateTime::Format::Flexible;
use Scalar::Util qw/blessed/;

my $natural_parser = DateTime::Format::Natural->new;

sub new {
    shift if $_[0] && $_[0] eq __PACKAGE__;

    my $parse;
    $parse = shift if @_ % 2;

    my %in = @_;
    $parse = delete $in{parse} if exists $in{parse};
    my $truncate = delete $in{truncate};
    my $convert = delete $in{convert};

    my ($saw_time_zone, $time_zone);
    $saw_time_zone = exists $in{timezone} || exists $in{time_zone};
    $time_zone = delete $in{timezone} if exists $in{timezone};
    $time_zone = delete $in{time_zone} if exists $in{time_zone}; # "time_zone" takes precedence over "timezone"
    $time_zone = "?" unless defined $time_zone;

    my ($parse_dt, $original_tz);
    if ($parse) {
        if (blessed $parse && $parse->isa("DateTime")) { # We have a DateTime object as $parse
            $original_tz = $parse->time_zone;
            $time_zone = $parse->time_zone unless $saw_time_zone;
            $parse_dt = $parse;
        }
        else {
            eval { # Try ::F::Flexible first...
                my $parse = $parse;
                my $tz;
                # ...but first, try to parse out any timezone information!
                if ($parse =~ s/\s+([A-Za-z][A-Za-z0-9\/\._]*)\s*$//) { # Look for a timezone-like string at the end of $parse
                    $tz = $1;
                    $parse = "$parse $tz" and undef $tz if $tz && $tz =~ m/^[ap]\.?m\.?$/i; # Put back AM/PM if we accidentally slurped it out
                }
                elsif ($parse =~ s/\s+([-+]\d+)\s*$//) {
                    $tz = $1;
                }
                $parse_dt = DateTime::Format::Flexible->build($parse);
                if ($tz) {
                    $time_zone = $tz if $time_zone eq "?"; 
                    $original_tz = $tz;
                }
            };
            if ($@ || ! $parse_dt) { # Failure, try ::F::Natural now...
                eval {
                    local $SIG{__WARN__} = sub {}; # Make sure ::Natural/Date::Calc stay quiet... don't really like this, oh well...
                    $parse_dt = $natural_parser->parse_datetime($parse);
                    return unless $natural_parser->success;
                };
            }
        }
    }

    $time_zone = "floating" if ! defined $time_zone || $time_zone eq "?";
    my $new_tz = $time_zone;

    my %DateTime;
    $DateTime{$_} = $parse_dt->$_ for qw/year month day hour minute second nanosecond/;
    $DateTime{time_zone} = $new_tz;
    @DateTime{keys %in} = values %in;
    
    return unless my $dt = DateTime->new(%DateTime);

    if ($convert) {
        if ($convert eq "1") {
        }
        else {
            $original_tz = $new_tz;
            $original_tz = "local" if $original_tz eq "floating";
            $new_tz = $convert;
        }
        $original_tz = "local" unless defined $original_tz;
        $dt->set_time_zone("floating");
        $dt->set_time_zone($original_tz);
        $dt->set_time_zone($new_tz);
    }

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

__END__
    my ($tz, $tz_offset);
    my %DateTime;
    if ($parse) {
        if (blessed $parse && $parse->isa("DateTime")) {
            $DateTime{$_} = $parse->$_ for qw/year month day hour minute second nanosecond time_zone/;
            $tz = (delete $DateTime{time_zone})->name;
            $time_zone = "?" unless $saw_time_zone;
        }
        else {
            return unless ($parse, $tz, $tz_offset) = UnixDate($parse, q/%Y %m %d %H %M %S/, qw/%Z %z/);
            @DateTime{qw/year month day hour minute second/} = split m/\s+/, $parse; 
        }
    }

    if ($time_zone eq "?") { # Use the timezone from parsing
        if (DateTime::TimeZone->is_valid_name($tz)) {
            $time_zone = $tz;
        }
        else {
            $time_zone = DateTime::Format::DateManip->get_dt_timezone($tz);
            $time_zone = $tz_offset if $tz_offset && ! $time_zone;
        }
    }
    elsif (DateTime::TimeZone->is_valid_name($time_zone)) { # User passed in a valid timezone already, we're done
    }
    else { # User passed in wonky timezone, let's see if we can match it up
        my $_time_zone = $time_zone;
        $time_zone = DateTime::Format::DateManip->get_dt_timezone($time_zone);
        die "Don't understand time zone ($_time_zone)" unless $time_zone
    }

    @DateTime{keys %in} = values %in;
    $DateTime{time_zone} = $time_zone;
    return unless my $dt = DateTime->new(%DateTime);
