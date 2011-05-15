use inc::Module::Install;
name 'Log-Sigil';
all_from 'lib/Log/Sigil.pm';

requires "Class::Singleton";
requires "Class::Accessor";
requires "Test::Exception";

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
