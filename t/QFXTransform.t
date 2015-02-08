use v6;

use Test;
plan 0;

use QFX::QFXDocument;
use QFX::QFXWriter;
use QFX::QFXManager;
use QFX::QFXPosition;

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
	$mgr.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "354855", secName => "ISHARES MSCI EAFE     ETF", ticker => "EFA"),
		units => "54",
		unitPrice => "74.65",
		mktVal => "4031.11",
		date => $date));
	$mgr.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "399747", secName => "ISHARES S&amp;P/TSX60 IDX ETF", ticker => "XIU"),
		units => "487",
		unitPrice => "20.91",
		mktVal => "10183.17",
		date => $date));
	$mgr.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "594671", secName => "SPDR S&amp;P 500 ETF", ticker => "SPY"),
		units => "26",
		unitPrice => "207.07",
		mktVal => "5383.86",
		date => $date));
	$mgr.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "706569", secName => "VANGUARD DIV APPR ETF", ticker => "VIG"),
		units => "27",
		unitPrice => "83.60",
		mktVal => "2257.27",
		date => $date));
	$mgr.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "706673", secName => "VANGUARD FTSE DEV MKT ETF", ticker => "VEA"),
		units => "77",
		unitPrice => "45.85",
		mktVal => "3530.68",
		date => $date));
	my $RBCMutFund = QFXMutualFund.new(uniqueId => "994875",
		secName => "RBC INV S/A-F    /NL'FRAC",
		ticker => "RBF2011",
		portions => QFXPortion.new(assetClass => "MONEYMRKT", percent => "100"));
	$mgr.addPosition(QFXPosition.new(
		instrument => $RBCMutFund,
		units => "1.987",
		unitPrice => "10.00",
		mktVal => "19.87",
		date => $date));
	$mgr.addDummy();
}
