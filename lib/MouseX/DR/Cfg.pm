package MouseX::DR::Cfg;
use Mouse;
extends 'Mouse::Meta::Attribute';

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
