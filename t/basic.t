use strict;
use warnings;
use utf8;
use lib 'lib';
use Test::More;
use Test::Mojo::DOM;
    
    use Test::More tests => 6;

    my $t;
    
    $t = Test::Mojo::DOM->new(MyApp->new);
    $t->get_ok('/')
        ->status_is(200)
        ->dom_inspector(sub {
            my $t = shift;
            ok $t->isa('Test::Mojo::DOM::Inspector'), 'right class';
            ok $t->dom->isa('Mojo::Collection'), 'right class';
            ok $t->dom->[0]->isa('Mojo::DOM'), 'right class';
        })
        ->status_is(200, 'can continue normal tests');

package MyApp;
use strict;
use warnings;
use base 'Mojo';

    sub handler {
        my ($self, $tx) = @_;
        $tx->res->code(200);
        $tx->res->body(<<'EOF');
<body>
    <div id="wrapper">
        <p id="some_p">
            <a href="../" empty="">some link</a>
            <a href="../">some link2</a>
            <a href="../">some link3</a>
        </p>
        <p id="some_p2">
        </p>
    </div>
    <img id="some_img" src="#" class="class1 class2 class3" />
</body>
EOF
        $tx->resume;
    }

__END__
