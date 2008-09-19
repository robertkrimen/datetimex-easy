#!perl

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use DateTimeX::Easy;
my $dt;

TODO: {
    local $TODO = "TBD";

    $dt = DateTimeX::Easy->new("2008-09-16 13:23:57 Eastern Daylight Time (GMT+05:00)");
    is($dt->time_zone->name, "US/Eastern");

    $dt = DateTimeX::Easy->new("2008-09-16 13:23:57 (GMT+05:00)");
    is($dt->time_zone->name, "US/Eastern");

    $dt = DateTimeX::Easy->new("2008-09-16 13:23:57 +05:00");
    is($dt->time_zone->name, "US/Eastern");
}

__END__
"2008-09-16 13:23:57 Eastern Daylight Time (GMT+05:00)"
perl -MDateTimeX::Easy -e 'print DateTimeX::Easy->new("2008-09-16
13:23:57 Eastern Daylight Time (GMT+05:00)");'

which actually works as:
"2008-09-16 13:23:57 (GMT+05:00)"
perl -MDateTimeX::Easy -e 'print DateTimeX::Easy->new("2008-09-16
13:23:57 (GMT+05:00)");'


