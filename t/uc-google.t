# Use case: HTTP GET until EOF
use warnings;
use strict;
use t::share;

if (CFG_ONLINE ne 'y') {
    plan skip_all => 'online tests disabled';
}

EV::Stream->new({
    host        => 'www.google.com',
    port        => 80,
    cb          => \&client,
    wait_for    => EOF,
    out_buf     => "GET / HTTP/1.0\nHost: www.google.com\n\n",
    in_buf_limit=> 102400,
    plugin      => [
        proxy       => EV::Stream::Proxy::HTTPS->new({
            host        => CFG_HOST,
            port        => CFG_PORT,
          ( CFG_USER ne q{} ? (
            user        => CFG_USER,
            pass        => CFG_PASS,
          ) : () ),
        }),
    ],
});

@CheckPoint = (
    [ 'client',     EOF             ], 'client: got eof',
);
plan tests => 1 + @CheckPoint/2;

EV::loop;

sub client {
    my ($io, $e, $err) = @_;
    checkpoint($e);
    like($io->{in_buf}, qr{\AHTTP/\d+\.\d+ }, 'got reply from web server');
    die "server error\n" if $e != EOF || $err;
    EV::unloop;
}

