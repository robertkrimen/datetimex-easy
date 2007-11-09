#!perl

use strict;
use warnings;

use Test::More qw/no_plan/;
use DateTimeX::Easy qw/parse_datetime datetime/;

my $dt;
$dt = DateTimeX::Easy->new("2007/01/01");
is("$dt", "2007-01-01T00:00:00");

$dt = DateTimeX::Easy->parse("2007/01/01 23:22:01");
is("$dt", "2007-01-01T23:22:01");

$dt = DateTimeX::Easy::parse("2007/01/01 10:22:01 PM");
is("$dt", "2007-01-01T22:22:01");

$dt = DateTimeX::Easy::new("2007/02/01 10:22:01 PM", hour => 9);
is("$dt", "2007-02-01T09:22:01");

$dt = parse_datetime("2007/01/04 10:22:01 PM", truncate => "year");
is("$dt", "2007-01-01T00:00:00");

$dt = DateTimeX::Easy->new(year => 2007, parse => "2007/01/01 23:22:01", timezone => "US/Eastern");
is("$dt", "2007-01-01T23:22:01");
is($dt->time_zone->name, "America/New_York");
$dt->set_time_zone("US/Pacific");
is("$dt", "2007-01-01T20:22:01");

$dt = datetime(parse => "2007/01/01 23:22:01", timezone => "US/Pacific");
is("$dt", "2007-01-01T23:22:01");

$dt = datetime(parse => "2007/01/01 23:22:01 US/Eastern", timezone => "US/Pacific");
is("$dt", "2007-01-01T20:22:01");
is($dt->time_zone->name, "America/Los_Angeles");

$dt = datetime(parse => "2007/01/01 23:22:01 -0500", timezone => "US/Pacific");
is("$dt", "2007-01-01T20:22:01");
is($dt->time_zone->name, "America/Los_Angeles");

$dt = datetime(parse => "2007/01/01 23:22:01 -0500");
is("$dt", "2007-01-01T23:22:01");
is($dt->time_zone->name, "-0500");
$dt->set_time_zone("US/Pacific");
is($dt->time_zone->name, "America/Los_Angeles");
is("$dt", "2007-01-01T20:22:01");

$dt = datetime(parse => "2007/01/01 23:22:01 PST8PDT", time_zone => "UTC");
is("$dt", "2007-01-02T07:22:01");
is($dt->time_zone->name, "UTC");

ok(datetime("2007-10"));

{
    $dt = DateTimeX::Easy->new("today");
    ok($dt);

    # Same thing:
    $dt = DateTimeX::Easy->new("now");
    ok($dt);

    # Uses Date::Manip's coolness:
    $dt = DateTimeX::Easy->new("last monday");
    ok($dt);

    # ... but in 1969:
    $dt = DateTimeX::Easy->new("last monday", year => 1969);
    ok($dt);

    # ... at the 100th nanosecond:
    $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100);
    ok($dt);

    # ... in US/Eastern: (This will NOT do a timezone conversion)
    $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Eastern");
    ok($dt);

    # This WILL do a proper timezone conversion:
    $dt = DateTimeX::Easy->new("last monday", year => 1969, nanosecond => 100, timezone => "US/Pacific");
    $dt->set_time_zone("America/New_York");
    ok($dt);
}

{
    my $eg;
    $eg = DateTimeX::Easy->parse("today"); # Will use a floating timezone
    ok($eg->time_zone->is_floating);

    $eg = DateTimeX::Easy->parse("2007-07-01 10:32:10"); # Will ALSO use a floating timezone
    ok($eg->time_zone->is_floating);
    is("$eg", "2007-07-01T10:32:10");

    $eg = DateTimeX::Easy->parse("2007-07-01 10:32:10 PM US/Eastern"); # Will use US/Eastern as a timezone
    ok(!$eg->time_zone->is_floating);
    is($eg->time_zone->name, "America/New_York");
    is("$eg", "2007-07-01T22:32:10");

    $eg = DateTimeX::Easy->parse("2007-07-01 10:32:10 PM", time_zone => "floating"); # Will use the floating timezone
    ok($eg->time_zone->is_floating);
    is("$eg", "2007-07-01T22:32:10");

    $eg = DateTimeX::Easy->parse("2007-07-01 10:32:10", time_zone_if_floating => "local"); # Will use the local timezone
    is($eg->time_zone->name, DateTime::TimeZone->new(name => "local")->name);

    $eg = DateTimeX::Easy->parse("2007-07-01 10:32:10 UTC", time_zone => "US/Pacific"); # Will convert from UTC to US/Pacific
    is($eg->time_zone->name, "America/Los_Angeles");
    is("$eg", "2007-07-01T03:32:10");

    my $dt = DateTime->new(year => 2007, month => 7, day => 1, hour => 22, minute => 32, second => 10)->set_time_zone("US/Eastern");
    $eg = DateTimeX::Easy->parse($dt); # Will use US/Eastern as the timezone
    is($eg->time_zone->name, "America/New_York");
    is("$eg", "2007-07-01T22:32:10");

    $eg = DateTimeX::Easy->parse($dt, time_zone => "floating"); # Will use a floating timezone
    ok($eg->time_zone->is_floating);
    is("$eg", "2007-07-01T22:32:10");

    # FIXED
    $eg = DateTimeX::Easy->parse($dt, time_zone => "PST8PDT", soft_time_zone_conversion => 1); # Will use "US/Pacific" as the timezone with *no* conversion
    is($eg->time_zone->name, "PST8PDT");
    is("$eg", "2007-07-01T22:32:10");

    $eg = DateTimeX::Easy->parse($dt)->set_time_zone("PST8PDT"); # Will use "US/Pacific" as the timezone WITH conversion
    is($eg->time_zone->name, "PST8PDT");
    is("$eg", "2007-07-01T19:32:10");

    $eg = DateTimeX::Easy->parse($dt, time_zone => "PST8PDT"); # Will ALSO use "US/Pacific" as the timezone WITH conversion
    is($eg->time_zone->name, "PST8PDT");
    is("$eg", "2007-07-01T19:32:10");

        $eg = DateTimeX::Easy->parse($dt, time_zone => "floating");
        is($eg->time_zone->name, "floating");
        is("$eg", "2007-07-01T22:32:10");
}
