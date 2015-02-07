use XML;
use QFX::QFXDocument;

class QFXManager {
	has QFXDocument $.doc;
	
	method setTextNode(Str $nodename, Str $newval) {
		my $element = self!findNode($nodename);
		my $existing = $element.firstChild();
		my $new = XML::Text.new(text => $newval);
		$element.replace($existing, $new);
	}
	
	method clearPositions() {
		self!clearNode("INVPOSLIST");
	}
	
	method !clearNode(Str $nodename) {
		my $element = self!findNode($nodename);
		while (my $child = $element.firstChild()) {
			$element.removeChild($child);
		}
		
	}
	
	method addInstrument(Str $nodename, Str $uniqueId, Str $units, Str $unitPrice, Str $mktVal, Str $date) {
		my $posList = self!findNode("INVPOSLIST");
		$posList.append($nodename, qq :to 'EOT');
<INVPOS>
	<SECID>
		<UNIQUEID>{$uniqueId}</UNIQUEID>
		<UNIQUEIDTYPE>ISM_SEC_ID</UNIQUEIDTYPE>
	</SECID>
	<HELDINACCT>CASH</HELDINACCT>
	<POSTYPE>LONG</POSTYPE>
	<UNITS>{$units}</UNITS>
	<UNITPRICE>{$unitPrice}</UNITPRICE>
	<MKTVAL>{$mktVal}</MKTVAL>
	<DTPRICEASOF>{$date}</DTPRICEASOF>
</INVPOS>
EOT

	}

	method !findNode(Str $nodename) {
		my $elements = $.doc.xml.getElementsByTagName($nodename);
		die "no matches for $nodename" unless $elements.elems > 0;
		die "too many matches for $nodename" if $elements.elems > 1;
		$elements[0];
	}
}
