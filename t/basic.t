package Template_Basic;
use strict;
use warnings;
use utf8;
use lib 'lib';
use Test::More;
use Test::Mojo::Dom;
    
    use Test::More tests => 34;

    my $t;
	
    $t = Test::Mojo::Dom->new(MyApp->new);
	$t->get_ok('/')
		->status_is(200)
        ->test_dom(sub {
            my $t = shift;
            $t->at('a')
                ->attr_is('href', '../')
                ->attr_isnt('href', './')
                ->attr_like('href', qr'\.\./')
                ->attr_unlike('href', qr'\.\./a')
                ->text_is('some link')
                ->text_isnt('some link2')
                ->text_like(qr'some')
                ->text_unlike(qr'some2')
				->has_attr('href')
				->has_attr('empty')
				->has_attr_not('not_exists');
            $t->find('a')->get(1)
				->text_is('some link2');
            $t->find('a')->each(sub {
				my $t = shift;
				$t->text_like(qr{.});
				$t->text_unlike(qr{a});
				$t->attr_like('href', qr{.});
				$t->attr_unlike('href', qr{a});
			});
			$t->at('a')->parent->attr_is('id', 'some_p');
			$t->at('a')->parent->parent->attr_is('id', 'wrapper');
			$t->at('#some_p')->has_child('a');
			$t->at('#some_p2')->has_child_not('a');
			
			$t->at('#some_img')->has_class('class1');
			$t->at('#some_img')->has_class('class2');
			$t->at('#some_img')->has_class('class3');
			$t->at('#some_img')->has_class_not('class4');
        });

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
