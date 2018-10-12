#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use open qw(:std :utf8);
use lib qw(lib ../lib t/lib);

use Test::More tests    => 10;
use Encode qw(decode encode);


BEGIN {
    use_ok 'MouseX::DR::Cfg';    
}


package Tst;
use Mouse;
use MouseX::DR::Cfg;


has vars =>
    is          => 'ro',
    isa         => 'Str',
    default     => sub { 123 },
    cfg         => { a => 'b', c => 'd' },
;

package main;

for my $o (new Tst) {
    isa_ok $o => Tst::;
    isa_ok $o->meta, 'Mouse::Meta::Class';
    is $o->vars, 123, 'vars value';
    can_ok $o->meta->get_attribute('vars'), 'cfg';
    for my $a ($o->meta->get_attribute('vars')) {
        is_deeply $a->cfg, { a => 'b', c => 'd' }, 'cfg';
        is_deeply $a->cfg('a'), 'b', 'cfg(a)';
        is_deeply $a->cfg('b'), undef, 'cfg(b)';
        is_deeply $a->cfg('c'), 'd', 'cfg(c)';
        is_deeply $a->cfg('', 12), 12, 'cfg("")';
    }
}
