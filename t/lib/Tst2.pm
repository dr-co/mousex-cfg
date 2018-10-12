use utf8;
use strict;
use warnings;

package Tst2;
use Mouse;
use MouseX::DR::Cfg;

has bla =>
    is      => 'ro',
    isa     => 'Num',
    cfg     => { a => 'b', c => 'd', class => __PACKAGE__ };

__PACKAGE__->meta->make_immutable;
