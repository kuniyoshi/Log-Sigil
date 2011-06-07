use inc::Module::Install;
name 'Log-Sigil';
all_from 'lib/Log/Sigil.pm';

requires "Class::Singleton";
requires "Class::Accessor";
requires "List::Util";
requires "Readonly";

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::Output';
test_requires 'Test::More';
test_requires "IO::Scalar";

auto_set_repository;
auto_include;
WriteAll;
