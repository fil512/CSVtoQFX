use QFX::QFXDocument;

grammar QFXXML {
	token TOP { ^ <itm>+ $ }
	token itm { ( <doctype> | <closetag> | <opentag> | <cdata> ) }
	token doctype { \< \? <-[>]>+ \> }
	token closetag { \< \/ <-[>]>+ \> }
	token opentag { \< <-[>]>+ \> }
	token cdata { <-[<>]>+ }
}
	
class QFXActions {
	has $.indent;
	has $.lastIsOpen;
	has $.outstring;
	method closetag($/) {
		$!outstring ~= '  ' x ($.indent - 1) unless $.lastIsOpen;
		$!outstring ~= "$/" ~ "\n";
		--$!indent;
		$!lastIsOpen = False;
	}
	method opentag($/) {
		++$!indent;
		$!outstring ~= "\n" if $.lastIsOpen;
		$!outstring ~= '  ' x ($.indent - 1) ~ "$/";
		$!lastIsOpen = True;
	}
	method cdata($/) {
		$!outstring ~= $/;
	}
}

class QFXWriter {
	has QFXDocument $.doc;
	
	method write(Str $filename) {
		my $output = open $filename, :w;
		self!writeKeys($output);
		self!writeXML($output);
		close $output;
	}

	method !writeKeys($output) {
		for @($.doc.parsed<keyval>) -> $kv {
			say $output: "$kv<key>:$kv<val>";
		}
	}
	
	method !writeXML($output) {
		my $xmlstr = self!format(~$.doc.xml);

		$xmlstr.=subst(/\<INTU_BID\>/, "<INTU.BID>");
		$xmlstr.=subst(/\<\/INTU_BID\>/, "</INTU.BID>");
		say $output: $xmlstr;
	}

	method !format(Str $xml) {
		my $actions = QFXActions.new();
		my $parsed = QFXXML.parse($xml, :$actions);
		$actions.outstring;
	}
}

