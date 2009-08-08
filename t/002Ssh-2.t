######################################################################
# Test suite for Net::SSH::AuthorizedKeysFile (ssh-2)
# by Mike Schilli <m@perlmeister.com>
######################################################################

use warnings;
use strict;
use Sysadm::Install qw(:all);
use File::Temp qw(tempfile);
use Log::Log4perl qw(:easy);
# Log::Log4perl->easy_init($DEBUG);

use Test::More tests => 10;
BEGIN { use_ok('Net::SSH::AuthorizedKeysFile') };

my $tdir = "t";
$tdir = "../t" unless -d $tdir;
my $cdir = "$tdir/canned";

use Net::SSH::AuthorizedKeysFile;

my $ak = Net::SSH::AuthorizedKeysFile->new(file => "$cdir/ak-ssh2.txt");

my @keys = $ak->keys();

is($keys[0]->type(), "ssh-2", "type");
is($keys[1]->type(), "ssh-2", "type");

is($keys[0]->key(), "AAAAAlkj2lkjalsdfkjlaskdfj234", "key");
is($keys[1]->key(), "AAAAAlkj2lkjalsdfkjlaskdfj234", "key");

is($keys[0]->email(), 'foo@bar.com', "key");
is($keys[1]->email(), 'bar@foo.com', "key");

# modify a ssh-2 key
my($fh, $filename) = tempfile();
cp "$cdir/ak-ssh2.txt", $filename;
$ak = Net::SSH::AuthorizedKeysFile->new(file => "$cdir/ak-ssh2.txt");

$ak = Net::SSH::AuthorizedKeysFile->new(file => $filename);

@keys = $ak->keys();

$keys[0]->key("123");
is($keys[0]->key(), "123", "modified key");
$ak->save();

$ak = Net::SSH::AuthorizedKeysFile->new(file => $filename);
is($keys[0]->key(), "123", "modified key");
is($keys[1]->key(), "AAAAAlkj2lkjalsdfkjlaskdfj234", "unmodified key");

