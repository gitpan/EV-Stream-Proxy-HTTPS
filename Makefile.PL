use inc::Module::Install;

name     'EV-Stream-Proxy-HTTPS';
all_from 'lib/EV/Stream/Proxy/HTTPS.pm';
author   'Alex Efros <powerman-asdf@ya.ru>';
license  'perl';

requires 'version';
requires 'EV::Stream';

test_requires 'Test::More';
test_requires 'Test::Exception';

my $online = prompt 'Run tests which require internet connection', 'n';
$online = lc $online eq 'y' ? 'y' : 'n';
my ($host, $port, $user, $pass);
if ($online eq 'y') {
    $host = prompt 'Please enter HTTPS proxy host', q{};
    $port = prompt 'Please enter HTTPS proxy port', q{};
    $user = prompt 'Please enter HTTPS proxy user', q{};
    $pass = prompt 'Please enter HTTPS proxy pass', q{};
}
open my $f, '>', 't/config.pm' or die "open: $!";
printf {$f} "use constant CFG_ONLINE => '%s';\n", $online;
printf {$f} "use constant CFG_HOST   => '%s';\n", $host;
printf {$f} "use constant CFG_PORT   => '%s';\n", $port;
printf {$f} "use constant CFG_USER   => '%s';\n", $user;
printf {$f} "use constant CFG_PASS   => '%s';\n", $pass;
printf {$f} '1;';
close $f or die "close: $!";

WriteAll;
