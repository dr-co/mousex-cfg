#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use open qw(:std :utf8);
use lib qw(lib ../lib t/lib);

use Test::More tests    => 2;
use Encode qw(decode encode);

package Tst;
use Mouse;

__PACKAGE__->meta->make_immutable;
package main;


for my $o (new Tst) {
    isa_ok $o => 'Tst';
    isa_ok $o->meta, 'Mouse::Meta::Class';
}
