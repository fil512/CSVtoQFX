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
	my $date = "20140425";
	$mgr.setTextNode("DTSERVER", $date);
	$mgr.setTextNode("TRNUID", "1398454374947");
	$mgr.setTextNode("DTASOF", "20140425120000");
	$mgr.setTextNode("DTSTART", $date);
	$mgr.setTextNode("DTEND", $date);
	$mgr.setTextNode("FITID", "1398454374947");
	$mgr.setTextNode("DTTRADE", $date);
	$mgr.setTextNode("AVAILCASH", "0.00");
	
	$mgr.clearPositions();
	$mgr.addInstrument("POSSTOCK", "354855", "54", "74.65", "4031.11", $date);
	$mgr.addInstrument("POSSTOCK", "399747", "487", "20.91", "10183.17", $date);
	$mgr.addInstrument("POSSTOCK", "594671", "26", "207.07", "5383.86", $date);
	$mgr.addInstrument("POSSTOCK", "706569", "27", "83.60", "2257.27", $date);
	$mgr.addInstrument("POSSTOCK", "706673", "77", "45.85", "3530.68", $date);

	$mgr.addInstrument("POSMF", "994875", "1.987", "10.00", "19.87", $date);

}
