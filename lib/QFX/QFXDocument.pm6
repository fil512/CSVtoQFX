use XML;

grammar QFXParser {
	token TOP { ^ <keyval>+ <ofx> $ }
	token keyval { $<key>=[\w+] ':' $<val>=[\w+] \n }
	token ofx { \<OFX\>.* }
}

class QFXDocument {
	has $.xml;
	has $.parsed;
	
	method parsefile(Str $filename) {
		$!parsed = QFXParser.parsefile($filename);
		my Str $xmlstring = "$.parsed<ofx>";
		$xmlstring.=subst(/\<INTU.BID\>/, "<INTU_BID>");
		$xmlstring.=subst(/\<\/INTU.BID\>/, "</INTU_BID>");
		$!xml = from-xml($xmlstring);
	}
}

