use v6;

use CSV::Parser;
use QFX::QFXDocument;
use QFX::QFXManager;
use QFX::QFXWriter;
use QFX::QFXPosition;
use QFX::QFXStatement;

class QFXFileProcessor {
  has $.template;
  has $.outputFolder;
  has $.trnPrefix;
  has $.brokerId;
  has $!acctId;
  has $!date;
  has $!trnuid;
  
  method processFile(Str $filename) {
    if $filename ~~ / $<account> = [ \w+ ] _ $<date> = [ \d\d\d\d\d\d\d\d ] \.txt $ / {
      $!acctId = ~$<account>;
      $!date = ~$<date>;
      $!trnuid = $.trnPrefix ~ $!date;
      my $outfile = "$.outputFolder/{$!acctId}_{$!date}.qfx";
      say "Translating $filename into $outfile";
      self.translate($filename, $outfile);
    } else {
      die "invalid filename format: $filename";
    }
  }

  method translate(Str $infile, Str $outfile) {
    my @records = self!readNBCSV($infile);
    say "parsed " ~ @records.elems ~ " records.";

    my $doc = QFXDocument.new;
    $doc.parsefile($.template);
    my $mgr = QFXManager.new(doc => $doc);
    $mgr.setStatement(self!process(@records));

    my $writer = QFXWriter.new( doc => $doc );
    $writer.write($outfile);
}

method !readNBCSV(Str $filename) {
  my $fh      = open $filename, :r;
  my $parser  = CSV::Parser.new( file_handle => $fh , contains_header_row => True );

  my @lines;
  while (my $line = $parser.get_line()) {
    @lines.push($line);
  }
  $fh.close;
  @lines;
}

method !process(@records) {
  my $cash = @records[0]<Cash>;
  my $statement = QFXStatement.new(
                brokerid => $.brokerId,
                acctid => $!acctId,
		date => $!date,
		trnuid => $!trnuid,
		availCash => $cash
	);
  for @records -> $record {
    	$statement.addPosition(self!getPosition($record));
  }
  $statement;
}

method !getPosition($record) {
  QFXPosition.new(
	instrument => self!getInstrument($record),
	units => $record{'Total quantity'}.Str,
	unitPrice => $record{'Market price'}.Str,
	mktVal => $record{'Market value'}.Str,
	date => self!cleanDate($record{'Evaluation date'}.Str));
}

method !getInstrument($record) {
  QFXStock.new(
    uniqueId => $record<Security>,
    secName => $record<Description>,
    ticker => $record<Symbol>);
}

method !cleanDate($date) {
  $date.subst(/\//, '', :g);
}
}