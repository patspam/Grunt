# N.B. Test with an actual server via: 
#  env PLACK_TEST_IMPL=Server prove

use strict;
use warnings;

use Plack::Test;
use Plack::Util;
use Test::More;
use HTTP::Request::Common;
use File::Basename;

my $app = Plack::Util::load_psgi( dirname(__FILE__) . '/../app.psgi' );

test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET '/run/test_simple');
    is $res->code, 200;
    is $res->content, <<END_RESPONSE, 'without arguments';
Running test_simple..
Test script called with arguments:
The end
END_RESPONSE
};

test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(GET '/run/test_simple?args=first&args=second');
    is $res->code, 200;
    is $res->content, <<END_RESPONSE, 'with arguments';
Running test_simple..
Test script called with arguments: first second
The end
END_RESPONSE
};

done_testing;
