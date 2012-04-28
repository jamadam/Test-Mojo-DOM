package Test::Mojo::Dom;
use Mojo::Base 'Test::Mojo';
  
  sub test_dom {
    my ($self, $cb) = @_;
    #local $Test::Builder::Level = $Test::Builder::Level + 1;
    $cb->(Test::Mojo::Dom::_Test->new($self->tx->res->dom));
  }

package Test::Mojo::Dom::_Test;
use Mojo::Base -base;
use Mojo::DOM;

  __PACKAGE__->attr('dom');
  
  sub new {
    my ($class, $dom) = @_;
    my $self = $class->SUPER::new;
    if (! $dom->isa('Mojo::Collection')) {
      $dom = Mojo::Collection->new($dom || Mojo::DOM->new);;
    }
    $self->dom($dom);
    return $self;
  }
  
  sub at {
    my ($self, $selector) = @_;
    return __PACKAGE__->new($self->dom->[0]->find($selector));
  }
  
  sub children {
    my ($self, $selector) = @_;
    return __PACKAGE__->new($self->dom->[0]->children($selector));
  }
  
  sub each {
    my ($self, $cb) = @_;
    return __PACKAGE__->new($self->dom->each(sub {
      $cb->(__PACKAGE__->new(shift));
    }));
  }
  
  sub get {
    my ($self, $index) = @_;
    return __PACKAGE__->new($self->dom->[$index]);
  }
  
  sub find {
    my ($self, $selector) = @_;
    return __PACKAGE__->new($self->dom->[0]->find($selector));
  }
  
  sub parent {
    my ($self) = @_;
    return __PACKAGE__->new($self->dom->[0]->parent);
  }
  
  sub root {
    my ($self) = @_;
    return __PACKAGE__->new($self->dom->[0]->root);
  }
  
  sub text_is {
    my ($self, $value, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::is $self->dom->[0]->text, $value, $desc || 'exact match for text';
    return $self;
  }
  
  sub text_isnt {
    my ($self, $value, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::isnt $self->dom->[0]->text, $value, $desc || 'no match for text';
    return $self;
  }
  
  sub text_like {
    my ($self, $value, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::like $self->dom->[0]->text, $value, $desc || 'text is similar';
    return $self;
  }
  
  sub text_unlike {
    my ($self, $value, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::unlike $self->dom->[0]->text, $value, $desc || 'text is not similar';
    return $self;
  }
  
  sub attr_is {
    my ($self, $name, $value, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::is $self->dom->[0]->attrs($name),
                                $value, $desc || 'exact match for attr value';
    return $self;
  }
  
  sub attr_isnt {
    my ($self, $name, $value, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::isnt $self->dom->[0]->attrs($name),
                                    $value, $desc || 'no match for attr value';
    return $self;
  }
  
  sub attr_like {
    my ($self, $name, $value, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::like $self->dom->[0]->attrs($name),
                                      $value, $desc || 'attr value is similar';
    return $self;
  }
  
  sub attr_unlike {
    my ($self, $name, $value, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::unlike $self->dom->[0]->attrs($name),
                                  $value, $desc || 'attr value is not similar';
    return $self;
  }
  
  sub has_attr {
    my ($self, $name, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::ok defined $self->dom->[0]->attrs($name),
                                            $desc || qq/has attribute "$name"/;
    return $self;
  }
  
  sub has_attr_not {
    my ($self, $name, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::ok ! defined $self->dom->[0]->attrs($name),
                                        $desc || qq/has attribute "$name" not/;
    return $self;
  }
  
  sub has_child {
    my ($self, $selector, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::ok $self->dom->[0]->at($selector),
                                            $desc || qq/has child "$selector"/;
    return $self;
  }
  
  sub has_child_not {
    my ($self, $selector, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    Test::More::ok !$self->dom->[0]->at($selector),
                                        $desc || qq/has child "$selector" not/;
    return $self;
  }
  
  sub has_class {
    my ($self, $name, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my $len = scalar grep {$_ eq $name} (split(/\s/, $self->dom->[0]->attrs('class')));
    Test::More::ok($len, $desc || qq/has child "$name"/);
    return $self;
  }
  
  sub has_class_not {
    my ($self, $name, $desc) = @_;
    local $Test::Builder::Level = $Test::Builder::Level + 1;
    my $len = scalar grep {$_ eq $name} (split(/\s/, $self->dom->[0]->attrs('class')));
    Test::More::ok(! $len, $desc || qq/has child "$name"/);
    return $self;
  }

1;
