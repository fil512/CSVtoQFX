use v6;

use Test;
plan 9;

use QFX::QFXDocument;
use QFX::QFXManager;

my $doc = QFXDocument.new();
$doc.parsefile('t/data/from-bank-feb.qfx');
my $parsed = $doc.parsed;

#test keyval part
is @($parsed<keyval>).elems, 9, 'number of keyvals';
my $kv = @($parsed<keyval>).[0];
is $kv.<key>, "OFXHEADER", "first header key";
is $kv.<val>, 100, "first header val";
$kv = @($parsed<keyval>).[8];
is $kv.<key>, "NEWFILEUID", "last header key";
is $kv.<val>, "NONE", "last header val";

# test xml part
my $xml = $doc.xml;
is $xml.root.name, "OFX", "first element";

my @dtserver = $xml.getElementsByTagName("DTSERVER");

is @dtserver.elems, 1, "only one dt server element";

my $dtServerVal = @dtserver[0].firstChild();
is $dtServerVal, 20140213, "date value";

my $mgr = QFXManager.new(doc => $doc);
my $newdate = "20150201";
$mgr.setTextNode("DTSERVER", $newdate);

$dtServerVal = @dtserver[0].firstChild();
is $dtServerVal, $newdate, "new date value";