use v6;

use Test;
plan 1;

use QFX::QFXDocument;
use QFX::QFXWriter;
use QFX::QFXManager;
use QFX::QFXPosition;
use QFX::QFXStatement;

my $SOURCE = 't/data/from-bank-feb.qfx';
my $OUTPUT = 't/data/output.qfx';
my $COMPARE = 't/data/from-bank-apr.qfx';

my $doc = QFXDocument.new;
$doc.parsefile($SOURCE);

my $mgr = QFXManager.new(doc => $doc);
transform($mgr);

my $writer = QFXWriter.new( doc => $doc );
$writer.write($OUTPUT);

my $outputStr = $writer.Str.subst(/\s/, '', :g);
my $compare = (slurp $COMPARE).subst(/\s/, '', :g);
ok $outputStr eq $compare;

sub transform(QFXManager $mgr) {
	my $date = "20140425";
	
	my $statement = QFXStatement.new(
		date => $date,
		acctid => "6K1046S",
		brokerid => "td.com",
		trnuid => "1398454374947",
		availCash => "0.00"
	);
	
	$statement.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "354855", secName => "ISHARES MSCI EAFE     ETF", ticker => "EFA"),
		units => "54",
		unitPrice => "74.65",
		mktVal => "4031.11",
		date => $date));
	$statement.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "399747", secName => "ISHARES S&amp;P/TSX60 IDX ETF", ticker => "XIU"),
		units => "487",
		unitPrice => "20.91",
		mktVal => "10183.17",
		date => $date));
	$statement.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "594671", secName => "SPDR S&amp;P 500 ETF", ticker => "SPY"),
		units => "26",
		unitPrice => "207.07",
		mktVal => "5383.86",
		date => $date));
	$statement.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "706569", secName => "VANGUARD DIV APPR ETF", ticker => "VIG"),
		units => "27",
		unitPrice => "83.60",
		mktVal => "2257.27",
		date => $date));
	$statement.addPosition(QFXPosition.new(
		instrument => QFXStock.new(uniqueId => "706673", secName => "VANGUARD FTSE DEV MKT ETF", ticker => "VEA"),
		units => "77",
		unitPrice => "45.85",
		mktVal => "3530.68",
		date => $date));
	my $RBCMutFund = QFXMutualFund.new(uniqueId => "994875",
		secName => "RBC INV S/A-F    /NL'FRAC",
		ticker => "RBF2011",
		portions => QFXPortion.new(assetClass => "MONEYMRKT", percent => "100"));
	$statement.addPosition(QFXPosition.new(
		instrument => $RBCMutFund,
		units => "1.987",
		unitPrice => "10.00",
		mktVal => "19.87",
		date => $date));

	$mgr.setStatement($statement);
	

}
