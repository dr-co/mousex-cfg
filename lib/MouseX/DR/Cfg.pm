package MouseX::DR::Cfg;
use Mouse;
extends 'Mouse::Meta::Attribute';

our $VERSION = '0.02';

has cfg    =>
    is          => 'ro',
    isa         => 'HashRef',
    lazy        => 1,
    default     => sub {{}};
use Scalar::Util 'looks_like_number';


around cfg => sub {
    my ($orig, $self, @args) = @_;
    return $self->$orig         unless @args;
    return $self->$orig(@args)  if @args > 2;
    my $name = $args[0];
    my $default = $args[1];
    return $default unless defined $name and length $name;
    my @sp = split /\./, $name;
    my $o = $self->$orig;

    for (@sp) {
        if ('HASH' eq ref $o) {
            return $default unless exists $o->{$_};
            $o = $o->{$_};
            next;
        }

        return $default unless length $_;
        
        if ('ARRAY' eq ref $o) {
            return $default unless looks_like_number $_;
            $o = $o->[$_];
            next;
        }
        return $default;
    }
    $o;
};

{
    no warnings 'redefine';

    sub Mouse::Meta::Class::attribute_metaclass {
        __PACKAGE__
    }
}



no Mouse;
__PACKAGE__->meta->make_immutable(inline_constructor => 0);

__END__

=head1 NAME

MouseX::DR::Cfg - Config tags for any meta attributes

=head1 SYNOPSIS

    package Foo;
    use Mouse;
    use MouseX::DR::Cfg;

    has foo     => is => 'ro', cfg => { jsonable => 1 };
    has bar     => is => 'ro', cfg => { jsonable => 0 };
    has baz     => is => 'ro', cfg => { jsonable => 1 };


    sub TO_JSON {
        my ($self) = @_;
        my %h;
        for ($self->get_attribute_list) {
            next unless $self->get_attribute($_)->cfg('jsonable');
            $h{ $_ } = $self->get_attribute($_);
        }
        return \%h;
    }

    __PACKAGE__->meta->make_immutable;

=head1 DESCRIPTION

The package replaces standard class L<Mouse::Meta::Attribute>
by L<MouseX::DR::Cfg>, so each attribute receives a hash B<cfg>.

You can access the hash through C<cfg> attribute.

    $self->get_attribute($name)->cfg->{a}{b}[3]{c};
    $self->get_attribute($name)->cfg('a.b.3.c');

=cut
