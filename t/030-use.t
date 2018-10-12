#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use open qw(:std :utf8);
use lib qw(lib ../lib t/lib);

use Test::More tests    => 8;
use Encode qw(decode encode);


BEGIN {
    use_ok 'Tst1';
    use_ok 'Tst2';
}

for (Tst1->meta->get_attribute('bla')) {
    isa_ok $_ => 'MouseX::DR::Cfg';
    is $_->cfg('class'), 'Tst1', 'class';
}

for (Tst2->meta->get_attribute('bla')) {
    isa_ok $_ => 'MouseX::DR::Cfg';
    is $_->cfg('class'), 'Tst2', 'class';
}

my $a = new Tst1 bla => 1;
my $b = new Tst2 bla => 2;
isa_ok $a => Tst1::;
isa_ok $b => Tst2::;

