use v6;
use XML;

grammar QFXParser {
	token TOP { ^ <keyval>+ <ofx> $ }
	token keyval { $<key>=[\w+] ':' $<val>=[\w+] \n }
	token ofx { \<OFX\>.* }
}

my $parsed =  QFXParser.parsefile('C:\Users\Ken\dev\perl\6K1046S-13-Feb-2014.qfx');


my Str $xmlstring = "$parsed<ofx>";
$xmlstring.=subst(/\<INTU.BID\>/, "<INTU_BID>");
$xmlstring.=subst(/\<\/INTU.BID\>/, "</INTU_BID>");
my $xml = from-xml($xmlstring);

my $output = open 'C:\Users\Ken\dev\perl\testoutput.qfx', :w;
for @($parsed<keyval>) -> $kv {
	say $output: "$kv<key>:$kv<val>";
}

my $xmlstr = format ~$xml;

$xmlstr.=subst(/\<INTU_BID\>/, "<INTU.BID>");
$xmlstr.=subst(/\<\/INTU_BID\>/, "</INTU.BID>");
say $output: $xmlstr;
close $output;

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

sub format (Str $xml) {
	my $actions = QFXActions.new();
	my $parsed = QFXXML.parse($xml, :$actions);
	$actions.outstring;
}
