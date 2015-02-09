use XML;
use QFX::QFXDocument;
use QFX::QFXPosition;
use QFX::QFXStatement;

class QFXManager {
	has QFXDocument $.doc;
	
	method setStatement(QFXStatement $statement) {
		self!setTextNode("DTSERVER", $statement.date);
		self!setTextNode("BROKERID", $statement.brokerid);
		self!setTextNode("ACCTID", $statement.acctid);
		self!setTextNode("TRNUID", $statement.trnuid);
		self!setTextNode("DTASOF", $statement.date ~ "120000");
		self!setTextNode("DTSTART", $statement.date);
		self!setTextNode("DTEND", $statement.date);
		self!setTextNode("FITID", $statement.trnuid);
		self!setTextNode("DTTRADE", $statement.date);
		self!setTextNode("AVAILCASH", $statement.availCash);
	
		self!clearPositions;
		for $statement.positions -> $position {
			self!addPosition($position);
		}
		self!addDummy;
	}
	
	method !setTextNode(Str $nodename, Str $newval) {
		my $element = self!findNode($nodename);
		my $existing = $element.firstChild;
		my $new = XML::Text.new(text => $newval);
		$element.replace($existing, $new);
	}
	
	method !clearPositions {
		self!clearNode("INVPOSLIST");
		self!clearNode("SECLIST");
	}
	
	method !clearNode(Str $nodename) {
		my $element = self!findNode($nodename);
		while (my $child = $element.firstChild) {
			$element.removeChild($child);
		}
		
	}
	
	method !addPosition(QFXPosition $pos) {
		my $posList = self!findNode("INVPOSLIST");
		$posList.append($pos.posType(), $pos.toPositionXML);
		my $secList = self!findNode("SECLIST");
		$secList.append($pos.secType, $pos.toSecInfoXML);
	}
	
	method !addDummy {
		my $secList = self!findNode("SECLIST");
		$secList.append("STOCKINFO", qq :to 'EOT');
<SECINFO>
	<SECID>
		<UNIQUEID>DUMMY_SECURITY</UNIQUEID>
		<UNIQUEIDTYPE>ISM_SEC_ID</UNIQUEIDTYPE>
	</SECID>
	<SECNAME>Sample security</SECNAME>
</SECINFO>
EOT
	}

	method !findNode(Str $nodename) {
		my $elements = $.doc.xml.getElementsByTagName($nodename);
		die "no matches for $nodename" unless $elements.elems > 0;
		die "too many matches for $nodename" if $elements.elems > 1;
		$elements[0];
	}
}
