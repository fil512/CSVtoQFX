use XML;
use QFX::QFXDocument;

class QFXManager {
	has QFXDocument $.doc;
	
	method setTextNode(Str $nodename, Str $newval) {
		my $elements = $.doc.xml.getElementsByTagName($nodename);
		die "no matches for $nodename" unless $elements.elems > 0;
		die "too many matches for $nodename" if $elements.elems > 1;
		my $element = $elements[0];
		my $existing = $element.firstChild();
		my $new = XML::Text.new(text => $newval);
		$element.replace($existing, $new);
	}
}
