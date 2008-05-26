#!perl

use strict;
use warnings;

use Test::More qw/no_plan/;
use DateTimeX::Easy qw/parse_datetime datetime/;

my $dt = DateTimeX::Easy->parse("Mon Mar 17, 2008 4:14 pm");
is($dt, "2008-03-17T16:14:00");
