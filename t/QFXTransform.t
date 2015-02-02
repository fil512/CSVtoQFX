use v6;

use Test;
plan 0;

use QFX::QFXDocument;
use QFX::QFXWriter;
use QFX::QFXManager;

my $doc = QFXDocument.new();
$doc.parsefile('t/data/from-bank-feb.qfx');

my $mgr = QFXManager.new(doc => $doc);
transform($mgr);

my $writer = QFXWriter.new( doc => $doc );
$writer.write('t/data/output.qfx');

sub transform(QFXManager $mgr) {
	my $startDate = "20140425";
	$mgr.setTextNode("DTSERVER", $startDate);
	$mgr.setTextNode("TRNUID", "1398454374947");
	$mgr.setTextNode("DTASOF", "20140425120000");
	$mgr.setTextNode("DTSTART", $startDate);
	$mgr.setTextNode("DTEND", $startDate);
	$mgr.setTextNode("FITID", "1398454374947");
	$mgr.setTextNode("DTTRADE", $startDate);
}
