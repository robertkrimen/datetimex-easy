#!/usr/bin/perl -w

use strict;

use DateTime;
use DateTimeX::Easy qw/datetime/;

my $dt = DateTime->from_epoch(epoch => time, time_zone => "local");
warn $dt->time_zone->name;


print datetime("first day of last month"), "\n";
print datetime("last day of last month"), "\n";
print datetime("last second of first month of last year"), "\n";
print datetime("last second of first month of year of 2005"), "\n";
print datetime("last second of last month of year of 2005"), "\n";

print datetime("beginning day of month of 2007-10-02"), "\n";
print datetime("end day of month of 2007-10-02"), "\n";
print datetime("last month of year of 2007"), "\n";

print datetime("last month of 2007"), "\n";
print datetime("end day of 2007-10-02"), "\n";
print datetime("beginning day of 2007-10-02"), "\n";
print datetime("last day of 2007"), "\n";
print datetime("last day of year of 2007"), "\n";
