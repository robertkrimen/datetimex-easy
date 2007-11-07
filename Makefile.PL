use inc::Module::Install;

name 'DateTimeX-Easy';
all_from 'lib/DateTimeX/Easy.pm';

build_requires 'Test::More';

auto_install;

WriteAll;

