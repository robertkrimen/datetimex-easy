use inc::Module::Install;

name 'DateTimeX-Easy';
all_from 'lib/DateTimeX/Easy.pm';

build_requires 'Test::More';

requires qw/DateTime/;
requires qw/DateTime::Format::DateParse/;
requires qw/DateTime::Format::Natural/;
requires qw/DateTime::Format::Flexible/;
requires qw/Scalar::Util/;
recommends qw/DateTime::Format::ICal/;
recommends qw/DateTime::Format::DateManip/;

auto_install;

WriteAll;

